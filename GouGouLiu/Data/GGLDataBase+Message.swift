//
//  GGLDataBase+Message.swift
//  GouGouLiu
//
//  Created by Harry Cao on 3/14/24.
//

import Foundation

extension GGLDataBase {
    func getMessageModel(ownerId: String, userId: String) -> GGLMessageModel {
        if let existMessageModel = fetchMessageModel(ownerId: ownerId, userId: userId) {
            return existMessageModel
        } else {
            let model = GGLMessageModel.create(ownerId: ownerId, userId: userId)
            addMessageModel(model)
            return model
        }
    }

    func addUnRead(messageModel: GGLMessageModel) {
        write {
            messageModel.unReadNum += 1
        }
        messageUnReadSubject.send(messageModel)
    }

    func clearUnRead(messageModel: GGLMessageModel) {
        write {
            messageModel.unReadNum = 0
        }
        messageUnReadSubject.send(messageModel)
    }

    func addMessageModel(_ messageModel: GGLMessageModel) {
        write {
            realm.add(messageModel)
        }
    }

    func insertChatModel(_ chatModel: GGLChatModel, to messageModel: GGLMessageModel) {
        write {
            messageModel.messages.insert(chatModel)
        }
    }

    func fetchMessageModels(ownerId: String?) -> [GGLMessageModel] {
        return realm.objects(GGLMessageModel.self).filter({
            $0.ownerId == ownerId
        }).sorted(by: {
            $0.compareTime > $1.compareTime
        })
    }

    func fetchMessageModel(ownerId: String, userId: String) -> GGLMessageModel? {
        return realm.objects(GGLMessageModel.self).filter("ownerId == %@ AND userId == %@", ownerId, userId).first
    }

    func deleteMessageModel(_ messageModel: GGLMessageModel) {
        write {
            realm.delete(messageModel)
        }
        messageUnReadSubject.send(messageModel)
    }
}
