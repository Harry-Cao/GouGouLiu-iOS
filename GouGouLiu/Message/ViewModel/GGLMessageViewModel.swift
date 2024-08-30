//
//  GGLMessageViewModel.swift
//  GouGouLiu
//
//  Created by Harry Cao on 3/14/24.
//

import SwiftUI
import Combine

final class GGLMessageViewModel: ObservableObject {
    @Published private(set) var messageModels: [GGLMessageModel] = []
    @Published private(set) var navigationTitle: String? = .Message
    var cancellables = Set<AnyCancellable>()

    init() {
        onReceivedMessage()
        subscribeUserUpdate()
        subscribeWebSocketStatus()
    }

    private func onReceivedMessage() {
        GGLWebSocketManager.shared.messageSubject.sink { [weak self] model in
            guard let self,
                  let contentType = model.content?.type else { return }
            switch contentType {
            case .system_logout:
                AppRouter.shared.popToRoot(animated: true)
                fallthrough
            case .peer_chat:
                self.updateData()
            case .peer_rtc:
                break
            }
        }.store(in: &cancellables)
    }

    private func subscribeUserUpdate() {
        GGLDataBase.shared.userUpdateSubject.sink { [weak self] _ in
            self?.updateData()
        }.store(in: &cancellables)
    }

    private func subscribeWebSocketStatus() {
        GGLWebSocketManager.shared.$connectStatus
            .sink { [weak self] status in
                guard let self, let _ = GGLUser.current else {
                    self?.navigationTitle = .Message
                    return
                }
                navigationTitle = status.navigationTitle ?? .Message
            }.store(in: &cancellables)
    }

    func updateData() {
        let userId = GGLUser.getUserId(showHUD: false)
        if let userId {
            setupSystemMessages(userId: userId)
        }
        messageModels = GGLDataBase.shared.fetchMessageModels(ownerId: userId)
    }

    private func setupSystemMessages(userId: String) {
        GGLSystemUser.allCases.forEach { object in
            guard GGLDataBase.shared.fetchMessageModel(ownerId: userId, userId: object.rawValue) == nil else { return }
            let messageModel = GGLMessageModel.create(ownerId: userId, userId: object.rawValue)
            GGLDataBase.shared.addMessageModel(messageModel)
            GGLDataBase.shared.insertChatModel(GGLChatModel.createText(object.welcomeWords, userId: object.rawValue), to: messageModel)
        }
    }

    func deleteDisabled(model: GGLMessageModel) -> Bool {
        if let _ = GGLSystemUser(rawValue: model.userId) {
            return true
        }
        return false
    }

    func onDelete(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let messageModel = messageModels[index]
        GGLDataBase.shared.deleteMessageModel(messageModel)
        messageModels.remove(at: index)
    }
}
