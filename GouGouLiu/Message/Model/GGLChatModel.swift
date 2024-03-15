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
    @Persisted var time = Date()
    @Persisted var type: GGLChatType

    @Persisted var userId: String
    @Persisted var content: String

    static func createText(userId: String, content: String) -> GGLChatModel {
        let model = GGLChatModel()
        model.type = .text
        model.userId = userId
        model.content = content
        return model
    }
}
