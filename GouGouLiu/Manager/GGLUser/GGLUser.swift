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

    static private(set) var current = GGLUserModel()
    static let networkHelper = GGLUserNetworkHelper()
    static let disposeBag = DisposeBag()

    static var userId: String? {
        get {
            return UserDefaults.userId
        } set {
            UserDefaults.userId = newValue
        }
    }
    static var userStatus: Status = .unregistered {
        didSet {
            if userStatus == .logout {
                userId = nil
            }
        }
    }

}

// MARK: - Request
extension GGLUser {

    static func signup(username: String, password: String) {
        networkHelper.requestSignup(username: username, password: password)
    }

    static func login(username: String, password: String) {
        networkHelper.requestLogin(username: username, password: password).subscribe(onNext: { model in
            guard let user = model.data else { return }
            current = user
            userId = current.userId
            ProgressHUD.showSucceed(model.msg)
        }).disposed(by: disposeBag)
    }

    static func logout() {
        guard let userId = GGLUser.getUserId() else { return }
        networkHelper.requestLogout(userId: userId).subscribe(onNext: { model in
            if model.code == 0 {
                userStatus = .logout
            }
            ProgressHUD.showSucceed(model.msg)
        }).disposed(by: disposeBag)
    }

    static func clearAll() {
        guard let userId = GGLUser.getUserId() else { return }
        networkHelper.requestClearAll(userId: userId).subscribe(onNext: { model in
            ProgressHUD.showSucceed(model.msg)
        }).disposed(by: disposeBag)
    }

}

// MARK: - Method
extension GGLUser {

    static func getUserId() -> String? {
        let userId = UserDefaults.userId
        if userId == nil {
            ProgressHUD.showFailed("请先登录")
        }
        return userId
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
