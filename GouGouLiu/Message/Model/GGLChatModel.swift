//
//  GGLChatModel.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2/26/24.
//

import RealmSwift

enum GGLChatType: String, PersistableEnum {
    case text
    case photo
}

enum GGLChatInputMode: CaseIterable {
    case text
    case speech
}

final class GGLChatModel: Object, Identifiable {
    @Persisted var id = UUID()
    @Persisted var createTime: TimeInterval
    @Persisted var type: GGLChatType

    @Persisted var userId: String
    @Persisted var text: String
    @Persisted var photoUrl: String

    static func createText(_ text: String, userId: String, createTime: TimeInterval? = nil) -> GGLChatModel {
        let model = GGLChatModel()
        model.type = .text
        model.userId = userId
        model.text = text
        model.createTime = createTime ?? Date.now.timeIntervalSince1970
        return model
    }

    static func createPhoto(_ photoUrl: String, userId: String, createTime: TimeInterval? = nil) -> GGLChatModel {
        let model = GGLChatModel()
        model.type = .photo
        model.userId = userId
        model.photoUrl = photoUrl
        model.createTime = createTime ?? Date.now.timeIntervalSince1970
        return model
    }
}
