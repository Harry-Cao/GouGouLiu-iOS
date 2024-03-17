//
//  GGLDataBase+Message.swift
//  GouGouLiu
//
//  Created by Harry Cao on 3/14/24.
//

import RxSwift

extension GGLDataBase {
    func subscribeMessage() {
        GGLWebSocketManager.shared.messageSubject.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] model in
            guard let self,
                  let ownerId = GGLUser.getUserId(showHUD: false),
                  let type = model.type else { return }
            switch type {
            case .peer_message:
                guard let senderId = model.senderId,
                      let content = model.message else { return }
                let chatModel = GGLChatModel.createText(userId: senderId, content: content)
                let messageModel: GGLMessageModel
                if let existMessageModel = fetchMessageModel(ownerId: ownerId, userId: senderId) {
                    messageModel = existMessageModel
                } else {
                    let model = GGLMessageModel.create(ownerId: ownerId, userId: senderId)
                    add(model)
                    messageModel = model
                }
                insert(chatModel, to: messageModel.messages)
                recordUnReadIfNeeded(messageModel: messageModel)
            }
        }).disposed(by: disposeBag)
    }

    private func recordUnReadIfNeeded(messageModel: GGLMessageModel) {
        if let topViewController = GGLTool.topViewController,
           let chatRoomViewController = topViewController as? GGLChatRoomViewController,
           chatRoomViewController.rootView.viewModel.messageModel.userId == messageModel.userId {
            return
        }
        write {
            messageModel.unReadNum += 1
        }
        messageUnReadSubject.onNext(messageModel)
    }

    func clearUnRead(messageModel: GGLMessageModel) {
        write {
            messageModel.unReadNum = 0
        }
        messageUnReadSubject.onNext(messageModel)
    }

    func fetchMessageModels(ownerId: String?) -> [GGLMessageModel] {
        return GGLDataBase.shared.objects(GGLMessageModel.self).filter({
            $0.ownerId == ownerId
        }).sorted(by: {
            $0.compareTime > $1.compareTime
        })
    }

    func fetchMessageModel(ownerId: String, userId: String) -> GGLMessageModel? {
        return GGLDataBase.shared.objects(GGLMessageModel.self).filter("ownerId == %@ AND userId == %@", ownerId, userId).first
    }

    func deleteMessageModel(_ messageModel: GGLMessageModel) {
        delete(messageModel)
        messageUnReadSubject.onNext(messageModel)
    }
}
