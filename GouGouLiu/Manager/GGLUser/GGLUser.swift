//
//  GGLUser.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/20/23.
//

import Foundation
import RxSwift
import ProgressHUD

final class GGLUser {

    static let current = GGLUser()
    private let networkHelper = GGLUserNetworkHelper()
    private let disposeBag = DisposeBag()

    var userId: String? {
        get {
            return UserDefaults.userId
        } set {
            UserDefaults.userId = newValue
        }
    }

    var username: String? {
        get {
            return UserDefaults.username
        } set {
            UserDefaults.username = newValue
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

// MARK: - Request
extension GGLUser {

    func signup(username: String, password: String) {
        // username, password 请求注册接口
        networkHelper.requestSignup(username: username, password: password).subscribe(onNext: { model in
            if model.code == 0 {
                GGLUser.current.username = username
                GGLUser.current.password = password
                ProgressHUD.showSucceed("注册成功")
            }
        }).disposed(by: disposeBag)
    }

    func login(username: String, password: String) {
        // username, password 请求登录接口
        networkHelper.requestLogin(username: username, password: password).subscribe(onNext: { model in
            if model.code == 0 {
                GGLUser.current.userStatus = .alreadyLogin
                ProgressHUD.showSucceed("登录成功")
            }
        }).disposed(by: disposeBag)
    }

    func logout() {
        // username 请求登出接口
        guard let username = GGLUser.current.username else { return }
        networkHelper.requestLogout(username: username).subscribe(onNext: { model in
            if model.code == 0 {
                GGLUser.current.userStatus = .logout
                ProgressHUD.showSucceed("登出成功")
            }
        }).disposed(by: disposeBag)
    }

}

// MARK: - Enum
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
