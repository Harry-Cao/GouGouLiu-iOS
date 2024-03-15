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
        GGLWebSocketManager.shared.textSubject.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] text in
            guard let self,
                  let model = GGLTool.jsonStringToModel(jsonString: text, to: GGLWebSocketModel.self),
                  let type = model.type else { return }
            switch type {
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
        let userId = GGLUser.getUserId()
        if let userId {
            setupSystemMessages(userId: userId)
        }
        messageModels = GGLDataBase.shared.fetchMessageModels(ownerId: userId)
    }

    private func setupSystemMessages(userId: String) {
        GGLSystemUser.allCases.forEach { object in
            guard GGLDataBase.shared.fetchMessageModels(ownerId: userId, userId: object.rawValue).isEmpty else { return }
            let messageObject = GGLMessageModel.create(ownerId: userId, userId: object.rawValue)
            GGLDataBase.shared.add(messageObject)
            GGLDataBase.shared.insert(GGLChatModel.createText(userId: object.rawValue, content: object.welcomeWords), to: messageObject.messages)
        }
    }
}
