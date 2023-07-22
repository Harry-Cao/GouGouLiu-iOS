//
//  UserDefaults+GGL.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/20/23.
//

import Foundation

extension UserDefaults {

    static var userId: String? {
        get {
            return UserDefaults.standard.string(forKey: "UserDefaults_userId")
        } set {
            UserDefaults.standard.set(newValue, forKey: "UserDefaults_userId")
        }
    }

}
