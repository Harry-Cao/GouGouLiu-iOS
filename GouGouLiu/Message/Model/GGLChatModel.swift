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

    mutating func toggle() {
        let allModes: [GGLChatInputMode] = GGLChatInputMode.allCases
        let currentIndex = allModes.firstIndex(of: self) ?? 0
        let nextIndex = currentIndex + 1 < allModes.count ? currentIndex + 1 : 0
        self = allModes[nextIndex]
    }
}

final class GGLChatModel: Object, Identifiable {
    @Persisted var id = UUID()
    @Persisted var createTime = Date()
    @Persisted var type: GGLChatType

    @Persisted var userId: String
    @Persisted var text: String
    @Persisted var photoUrl: String

    static func createText(userId: String, content: String) -> GGLChatModel {
        let model = GGLChatModel()
        model.type = .text
        model.userId = userId
        model.text = content
        return model
    }

    static func createPhoto(userId: String, photoUrl: String) -> GGLChatModel {
        let model = GGLChatModel()
        model.type = .photo
        model.userId = userId
        model.photoUrl = photoUrl
        return model
    }
}
