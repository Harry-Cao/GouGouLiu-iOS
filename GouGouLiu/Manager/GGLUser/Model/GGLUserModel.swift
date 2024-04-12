//
//  GGLUserModel.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/22/23.
//

import Foundation
import RealmSwift

final class GGLUserModel: Object, Codable {
    @Persisted var userId: String?
    @Persisted var userName: String?
    @Persisted var avatarUrl: String?

    static func create(userId: String, userName: String? = nil, avatarUrl: String? = nil) -> GGLUserModel {
        let model = GGLUserModel()
        model.userId = userId
        model.userName = userName
        model.avatarUrl = avatarUrl
        return model
    }
}

extension GGLUserModel: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = GGLUserModel()
        copy.userId = userId
        copy.userName = userName
        copy.avatarUrl = avatarUrl
        return copy
    }
}
