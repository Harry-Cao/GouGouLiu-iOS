//
//  GGLMessageModel.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/18.
//

import RealmSwift

final class GGLMessageModel: Object, Identifiable {
    @Persisted var id = UUID()
    @Persisted var createTime = Date()
    @Persisted var ownerId: String
    @Persisted var userId: String
    @Persisted var messages: MutableSet<GGLChatModel>
    @Persisted var unReadNum: Int

    var compareTime: Date {
        if let lastMessage = messages.last {
            return lastMessage.createTime
        }
        return createTime
    }

    var displayText: String {
        guard let lastMessage = messages.last else { return "" }
        switch lastMessage.type {
        case .text:
            return lastMessage.text
        case .photo:
            return "[图片]"
        }
    }

    static func create(ownerId: String, userId: String) -> GGLMessageModel {
        let model = GGLMessageModel()
        model.ownerId = ownerId
        model.userId = userId
        return model
    }
}
