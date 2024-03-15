//
//  GGLDataBase+User.swift
//  GouGouLiu
//
//  Created by Harry Cao on 3/15/24.
//

import Foundation

extension GGLDataBase {
    func saveOrUpdateUser(_ newValue: GGLUserModel) {
        let results = objects(GGLUserModel.self).filter({ $0.userId == newValue.userId })
        if let user = results.first {
            write {
                user.userName = newValue.userName
                user.avatarUrl = newValue.avatarUrl
            }
        } else {
            add(newValue)
        }
        userUpdateSubject.onNext(newValue)
    }
}
