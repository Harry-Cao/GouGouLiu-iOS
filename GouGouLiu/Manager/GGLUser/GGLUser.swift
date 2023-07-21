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
            if newValue == .logout {
                removeUserData()
            }
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
                GGLUser.current.userId = model.data?["userId"] as? String
            }
            ProgressHUD.showSucceed(model.msg)
        }).disposed(by: disposeBag)
    }

    func login(username: String, password: String) {
        // username, password 请求登录接口
        networkHelper.requestLogin(username: username, password: password).subscribe(onNext: { model in
            if model.code == 0 {
                GGLUser.current.username = username
                GGLUser.current.password = password
                GGLUser.current.userId = model.data?["userId"] as? String
                GGLUser.current.userStatus = .alreadyLogin
            }
            ProgressHUD.showSucceed(model.msg)
        }).disposed(by: disposeBag)
    }

    func logout() {
        // username 请求登出接口
        guard let userId = GGLUser.current.getUserId() else { return }
        networkHelper.requestLogout(userId: userId).subscribe(onNext: { model in
            if model.code == 0 {
                GGLUser.current.userStatus = .logout
            }
            ProgressHUD.showSucceed(model.msg)
        }).disposed(by: disposeBag)
    }

    func clearAll() {
        guard let userId = GGLUser.current.getUserId() else { return }
        networkHelper.requestClearAll(userId: userId).subscribe(onNext: { model in
            ProgressHUD.showSucceed(model.msg)
        }).disposed(by: disposeBag)
    }

}

// MARK: - Method
extension GGLUser {

    func getUserId() -> String? {
        let userId = UserDefaults.userId
        if userId == nil {
            // 跳转到登录界面
            ProgressHUD.showFailed("请先登录")
        }
        return userId
    }

    private func removeUserData() {
        userId = nil
        username = nil
        password = nil
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
