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

    static var account: String? {
        get {
            return UserDefaults.standard.string(forKey: "UserDefaults_account")
        } set {
            UserDefaults.standard.set(newValue, forKey: "UserDefaults_account")
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
