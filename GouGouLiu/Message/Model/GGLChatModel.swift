//
//  GGLChatModel.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2/26/24.
//

import RealmSwift

enum GGLChatType: String, PersistableEnum {
    case text
}

enum GGLChatRole: String, PersistableEnum {
    case user
    case other
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

class GGLChatModel: Object, Identifiable {
    @Persisted(primaryKey: true) var id = UUID()
    @Persisted var time = Date()
    @Persisted var type: GGLChatType

    @Persisted var role: GGLChatRole
    @Persisted var content: String
    @Persisted var avatar: String?

    static func createText(type: GGLChatType = .text, role: GGLChatRole, content: String, avatar: String?) -> GGLChatModel {
        let model = GGLChatModel()
        model.type = type
        model.role = role
        model.content = content
        model.avatar = avatar
        return model
    }
}
