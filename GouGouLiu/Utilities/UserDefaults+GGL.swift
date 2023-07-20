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

    static var username: String? {
        get {
            return UserDefaults.standard.string(forKey: "UserDefaults_username")
        } set {
            UserDefaults.standard.set(newValue, forKey: "UserDefaults_username")
        }
    }

    static var password: String? {
        get {
            return UserDefaults.standard.string(forKey: "UserDefaults_password")
        } set {
            UserDefaults.standard.set(newValue, forKey: "UserDefaults_password")
        }
    }

    static var userStatus: Int? {
        get {
            return UserDefaults.standard.integer(forKey: "UserDefaults_userStatus")
        } set {
            UserDefaults.standard.set(newValue, forKey: "UserDefaults_userStatus")
        }
    }

}
