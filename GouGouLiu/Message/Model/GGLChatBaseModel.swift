//
//  GGLChatBaseModel.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2/26/24.
//

import Foundation

enum GGLChatType {
    case text
}

enum GGLChatRole {
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

class GGLChatBaseModel: Identifiable {
    let id = UUID()
    var type: GGLChatType

    init(type: GGLChatType) {
        self.type = type
    }
}

extension GGLChatBaseModel: Equatable {
    static func == (lhs: GGLChatBaseModel, rhs: GGLChatBaseModel) -> Bool {
        return lhs.id == rhs.id
    }
}

final class GGLChatTextModel: GGLChatBaseModel {
    let role: GGLChatRole
    let content: String
    let avatar: String?

    init(role: GGLChatRole, content: String, avatar: String?) {
        self.role = role
        self.content = content
        self.avatar = avatar
        super.init(type: .text)
    }
}
