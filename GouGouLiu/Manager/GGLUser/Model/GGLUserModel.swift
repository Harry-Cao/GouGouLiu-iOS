//
//  GGLUserModel.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/22/23.
//

import RealmSwift

final class GGLUserModel: Object, Codable {
    @Persisted var userId: String?
    @Persisted var userName: String?
    @Persisted var avatarUrl: String?

    static func create(userId: String) -> GGLUserModel {
        let model = GGLUserModel()
        model.userId = userId
        return model
    }

    static func createSystem(userId: String, userName: String, avatarUrl: String) -> GGLUserModel {
        let model = GGLUserModel()
        model.userId = userId
        model.userName = userName
        model.avatarUrl = avatarUrl
        return model
    }
}
