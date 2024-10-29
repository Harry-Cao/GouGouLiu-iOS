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
                user.avatar = newValue.avatar
            }
        } else {
            addUser(newValue)
        }
        userUpdateSubject.send(newValue)
    }

    func addUser(_ userModel: GGLUserModel) {
        write {
            realm.add(userModel)
        }
    }

    func fetchUser(_ userId: String) -> GGLUserModel? {
        return realm.object(ofType: GGLUserModel.self, forPrimaryKey: userId)
    }

    func deleteAllUsers() {
        write {
            let allUsers = realm.objects(GGLUserModel.self)
            realm.delete(allUsers)
        }
    }
}
