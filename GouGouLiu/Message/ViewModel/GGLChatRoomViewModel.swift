//
//  GGLChatRoomViewModel.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2/27/24.
//

import SwiftUI
import RxSwift

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
    private let disposeBag = DisposeBag()

    init(messageModel: GGLMessageModel) {
        self.messageModel = messageModel
        onReceivedMessage()
        subscribeUserUpdate()
        updateMessageModel()
    }

    private func onReceivedMessage() {
        GGLWebSocketManager.shared.textSubject.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] text in
            guard let self,
                  let model = GGLTool.jsonStringToModel(jsonString: text, to: GGLWebSocketModel.self),
                  model.senderId == messageModel.userId,
                  let type = model.type else { return }
            switch type {
            case .peer_message:
                self.scrollToBottom()
            }
        }).disposed(by: disposeBag)
    }

    private func subscribeUserUpdate() {
        GGLDataBase.shared.userUpdateSubject.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] user in
            guard let self else { return }
            self.messageModel = self.messageModel
        }).disposed(by: disposeBag)
    }

    private func updateMessageModel() {
        GGLDataBase.shared.updateMessageModel(messageModel)
    }

    func sendMessage() {
        guard !inputText.isEmpty,
              let userId = GGLUser.getUserId() else { return }
        let prompt = inputText
        inputText = ""
        let model = GGLChatModel.createText(userId: userId, content: prompt)
        scrollToBottom()
        GGLDataBase.shared.insert(model, to: messageModel.messages)
        respondMessage = ""
        if !handleSystemSending(prompt) {
            GGLWebSocketManager.shared.sendPeerMessage(prompt, targetId: messageModel.userId)
        }
    }

    private func handleSystemSending(_ prompt: String) -> Bool {
        guard let systemId = GGLSystemUser(rawValue: messageModel.userId) else { return false }
        responding = true
        switch systemId {
        case .clientService:
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
        let model = GGLChatModel.createText(userId: messageModel.userId, content: respondMessage)
        scrollToBottom()
        GGLDataBase.shared.insert(model, to: messageModel.messages)
    }

    private func scrollToBottom() {
        scrollToBottomFlag.toggle()
    }
}
