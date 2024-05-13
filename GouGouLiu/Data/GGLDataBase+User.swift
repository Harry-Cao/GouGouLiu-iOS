//
//  GGLDataBase+User.swift
//  GouGouLiu
//
//  Created by Harry Cao on 3/15/24.
//

import Foundation

extension GGLDataBase {
    func saveOrUpdateUser(_ newValue: GGLUserModel) {
        if let user = realm.object(ofType: GGLUserModel.self, forPrimaryKey: newValue.userId) {
            write {
                user.userName = newValue.userName
                user.avatarUrl = newValue.avatarUrl
            }
        } else {
            add(newValue)
        }
        userUpdateSubject.send(newValue)
    }

    func fetchUser(_ userId: String) -> GGLUserModel? {
        return GGLDataBase.shared.realm.object(ofType: GGLUserModel.self, forPrimaryKey: userId)
    }
}
