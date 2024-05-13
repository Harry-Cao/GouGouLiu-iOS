//
//  GGLChatRoomViewModel.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2/27/24.
//

import SwiftUI
import Combine

final class GGLChatRoomViewModel: ObservableObject {
    @Published var messageModel: GGLMessageModel
    @Published var scrollToBottomFlag = false
    @Published var inputMode: GGLChatInputMode = .text
    @Published var inputText: String = ""
    @Published var responding: Bool = false
    @Published var respondMessage: String = ""
    let respondId = UUID()
    var sendDisabled: Bool {
        return responding
    }
    var isSystemUser: Bool {
        if let _ = GGLSystemUser(rawValue: messageModel.userId) {
            return true
        }
        return false
    }
    private let networkHelper = GGLChatRoomNetworkHelper()
    private var cancellables = Set<AnyCancellable>()

    init(messageModel: GGLMessageModel) {
        self.messageModel = messageModel
        onReceivedMessage()
        subscribeUserUpdate()
        updateMessageModel()
    }

    private func onReceivedMessage() {
        GGLWebSocketManager.shared.messageSubject.sink { [weak self] model in
            guard let self,
                  model.senderId == messageModel.userId,
                  let type = model.type else { return }
            switch type {
            case .peer_message:
                self.scrollToBottom()
            case .system_logout, .rtc_message:
                break
            }
        }.store(in: &cancellables)
    }

    private func subscribeUserUpdate() {
        GGLDataBase.shared.userUpdateSubject.sink { [weak self] user in
            guard let self else { return }
            self.messageModel = self.messageModel
        }.store(in: &cancellables)
    }

    private func updateMessageModel() {
        GGLDataBase.shared.updateMessageModel(messageModel)
    }

    func switchInputModel() {
        inputMode = GGLTool.toggleEnumCase(inputMode)
    }

    func sendPhoto() {
        guard let userId = GGLUser.getUserId() else { return }
        GGLUploadPhotoManager.shared.pickImage { [weak self] image in
            guard let self,
                  let data = image?.fixOrientation().jpegData(compressionQuality: 0) else { return }
            GGLUploadPhotoManager.shared.uploadPhoto(data: data, type: .chat, contactId: messageModel.ownerId) { progress in
                ProgressHUD.showServerProgress(progress: progress)
            } completion: { model in
                ProgressHUD.showServerMsg(model: model)
                guard model.code == .success,
                      let url = model.data?.previewUrl else { return }
                let photoModel = GGLChatModel.createPhoto(url, userId: userId)
                GGLDataBase.shared.insert(photoModel, to: self.messageModel.messages)
                self.scrollToBottom()
                GGLWebSocketManager.shared.sendPeerPhoto(url, targetId: self.messageModel.userId)
            }
        }
    }

    func sendMessage() {
        guard !inputText.isEmpty,
              let userId = GGLUser.getUserId() else { return }
        let prompt = inputText
        inputText = ""
        let model = GGLChatModel.createText(prompt, userId: userId)
        GGLDataBase.shared.insert(model, to: messageModel.messages)
        scrollToBottom()
        respondMessage = ""
        if !handleSystemSending(prompt) {
            GGLWebSocketManager.shared.sendPeerText(prompt, targetId: messageModel.userId)
        }
    }

    private func handleSystemSending(_ prompt: String) -> Bool {
        guard let systemUser = GGLSystemUser(rawValue: messageModel.userId) else { return false }
        responding = true
        switch systemUser {
        case .customerService:
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
                    guard let self else { return }
                    self.respondMessage.append("答复")
                    if self.respondMessage.count > 20 {
                        self.receivedAnswer()
                        timer.invalidate()
                    }
                }
            }
        case .gemini:
            Task {
                let responseStream = GGLGoogleAI.shared.chat.sendMessageStream(prompt)
                for try await chunk in responseStream {
                    if let text = chunk.text {
                        DispatchQueue.main.async { [weak self] in
                            self?.respondMessage += text
                        }
                    }
                }
                DispatchQueue.main.async { [weak self] in
                    self?.receivedAnswer()
                }
            }
        }
        return true
    }

    private func receivedAnswer() {
        responding = false
        let model = GGLChatModel.createText(respondMessage, userId: messageModel.userId)
        scrollToBottom()
        GGLDataBase.shared.insert(model, to: messageModel.messages)
    }

    private func scrollToBottom() {
        scrollToBottomFlag.toggle()
    }

    func clearUnRead() {
        GGLDataBase.shared.clearUnRead(messageModel: messageModel)
    }

    func onClickPhoneCall() {
        networkHelper.requestChannelId(senderId: messageModel.ownerId, targetId: messageModel.userId) { [weak self] model in
            guard let self,
                  let channelId = model.data?.channelId else { return }
            AppRouter.shared.present(GGLRtcViewController(role: .sender, type: .voice, channelId: channelId, targetId: messageModel.userId))
        }
    }

    func onClickVideoCall() {
        networkHelper.requestChannelId(senderId: messageModel.ownerId, targetId: messageModel.userId) { [weak self] model in
            guard let self,
                  let channelId = model.data?.channelId else { return }
            AppRouter.shared.present(GGLRtcViewController(role: .sender, type: .video, channelId: channelId, targetId: messageModel.userId))
        }
    }
}
