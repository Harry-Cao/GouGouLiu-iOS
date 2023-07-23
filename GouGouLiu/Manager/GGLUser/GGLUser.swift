//
//  GGLUser.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/20/23.
//

import Foundation
import RxSwift

final class GGLUser {

    static private(set) var current: GGLUserModel? {
        didSet {
            UserDefaults.userId = current?.userId
        }
    }
    static let networkHelper = GGLUserNetworkHelper()
    static let disposeBag = DisposeBag()

}

// MARK: - Request
extension GGLUser {

    static func signup(username: String, password: String) {
        networkHelper.requestSignup(username: username, password: password).subscribe(onNext: { model in
            ProgressHUD.showSucceed(model.msg)
        }).disposed(by: disposeBag)
    }

    static func login(username: String, password: String) {
        networkHelper.requestLogin(username: username, password: password).subscribe(onNext: { model in
            if model.code == 0,
               let user = model.data {
                current = user
            }
            ProgressHUD.showSucceed(model.msg)
        }).disposed(by: disposeBag)
    }

    static func logout() {
        guard let userId = GGLUser.getUserId() else { return }
        networkHelper.requestLogout(userId: userId).subscribe(onNext: { model in
            current = nil
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
