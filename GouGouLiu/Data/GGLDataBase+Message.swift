//
//  GGLDataBase+Message.swift
//  GouGouLiu
//
//  Created by Harry Cao on 3/14/24.
//

import RxSwift

extension GGLDataBase {
    func subscribeMessage() {
        GGLWebSocketManager.shared.textSubject.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] text in
            guard let self,
                  let ownerId = GGLUser.getUserId(showHUD: false),
                  let model = GGLTool.jsonStringToModel(jsonString: text, to: GGLWebSocketModel.self),
                  let type = model.type else { return }
            switch type {
            case .peer_message:
                guard let senderId = model.senderId,
                      let content = model.message else { return }
                let chatModel = GGLChatModel.createText(userId: senderId, content: content)
                let results = GGLDataBase.shared.objects(GGLMessageModel.self).filter("ownerId == %@ AND userId == %@", ownerId, senderId)
                if let existMessageModel = results.first {
                    self.insert(chatModel, to: existMessageModel.messages)
                } else {
                    let messageModel = GGLMessageModel.create(ownerId: ownerId, userId: senderId)
                    self.add(messageModel)
                    self.insert(chatModel, to: messageModel.messages)
                }
            }
        }).disposed(by: disposeBag)
    }

    func fetchMessageModels(ownerId: String?) -> [GGLMessageModel] {
        return GGLDataBase.shared.objects(GGLMessageModel.self).filter({ $0.ownerId == ownerId }).sorted(by: { model1, model2 in
            model1.messages.last?.time ?? Date() > model2.messages.last?.time ?? Date()
        })
    }

    func fetchMessageModels(ownerId: String, userId: String) -> [GGLMessageModel] {
        return GGLDataBase.shared.objects(GGLMessageModel.self).filter("ownerId == %@ AND userId == %@", ownerId, userId).map({ $0 })
    }
}
