//
//  GGLMessageModel.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/18.
//

import RealmSwift

enum GGLMessageType: String, PersistableEnum {
    case normal
    case gemini
}

final class GGLMessageModel: Object, Identifiable {
    @Persisted(primaryKey: true) var id = UUID()
    @Persisted var type: GGLMessageType = .normal
    @Persisted var avatar: String?
    @Persisted var name: String
    @Persisted var updateTime: Date = Date()
    @Persisted var messages: MutableSet<GGLChatModel>

    static func create(type: GGLMessageType = .normal, avatar: String?, name: String, updateTime: Date = Date()) -> GGLMessageModel {
        let model = GGLMessageModel()
        model.type = type
        model.avatar = avatar
        model.name = name
        model.updateTime = updateTime
        return model
    }
}

extension GGLDataBase {
    func getAllMessages() {
        
    }
}
