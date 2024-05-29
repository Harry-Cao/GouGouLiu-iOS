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
    private var cancellables = Set<AnyCancellable>()

    init() {
        onReceivedMessage()
        subscribeUserUpdate()
    }

    private func onReceivedMessage() {
        GGLWebSocketManager.shared.messageSubject.sink { [weak self] model in
            guard let self,
                  let type = model.type else { return }
            switch type {
            case .system_logout:
                AppRouter.shared.popToRoot(animated: true)
                fallthrough
            case .peer_message:
                self.updateData()
            case .rtc_message:
                break
            }
        }.store(in: &cancellables)
    }

    private func subscribeUserUpdate() {
        GGLDataBase.shared.userUpdateSubject.sink { [weak self] _ in
            self?.updateData()
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
