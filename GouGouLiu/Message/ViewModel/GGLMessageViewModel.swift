//
//  GGLMessageViewModel.swift
//  GouGouLiu
//
//  Created by Harry Cao on 3/14/24.
//

import SwiftUI
import RxSwift

final class GGLMessageViewModel: ObservableObject {
    @Published var messageModels: [GGLMessageModel] = []
    private let disposeBag = DisposeBag()

    init() {
        onReceivedMessage()
        subscribeUserUpdate()
    }

    private func onReceivedMessage() {
        GGLWebSocketManager.shared.messageSubject.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] model in
            guard let self,
                  let type = model.type else { return }
            switch type {
            case .system_logout:
                AppRouter.shared.popToRoot(animated: true)
                fallthrough
            case .peer_message:
                self.updateData()
            }
        }).disposed(by: disposeBag)
    }

    private func subscribeUserUpdate() {
        GGLDataBase.shared.userUpdateSubject.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            self?.updateData()
        }).disposed(by: disposeBag)
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
            let messageObject = GGLMessageModel.create(ownerId: userId, userId: object.rawValue)
            GGLDataBase.shared.add(messageObject)
            GGLDataBase.shared.insert(GGLChatModel.createText(object.welcomeWords, userId: object.rawValue), to: messageObject.messages)
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
