//
//  GGLUser.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/20/23.
//

import Foundation

final class GGLUser {

    static let current = GGLUser()

    var userId: String? {
        get {
            return UserDefaults.userId
        } set {
            UserDefaults.userId = newValue
        }
    }

    var account: String? {
        get {
            return UserDefaults.account
        } set {
            UserDefaults.account = newValue
        }
    }

    var password: String? {
        get {
            return UserDefaults.password
        } set {
            UserDefaults.password = newValue
        }
    }

    var userStatus: Status {
        get {
            guard let userStatusValue = UserDefaults.userStatus,
                  let userStatus = Status(rawValue: userStatusValue)
            else { return .unregistered }
            return userStatus
        } set {
            UserDefaults.userStatus = newValue.rawValue
        }
    }

}

extension GGLUser {

    func signup(account: String, password: String) {
        // account, password 请求注册接口
        // 成功则保存
    }

    func login() {
        // account, password 请求登录接口
    }

    func logout() {
        // account 请求登出接口
    }

}

extension GGLUser {

    enum Status: Int {
        /// 未注册
        case unregistered
        /// 已登录
        case alreadyLogin
        /// 退出登录
        case logout
    }

}
