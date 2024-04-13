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
            if let current {
                DispatchQueue.main.async {
                    GGLDataBase.shared.saveOrUpdateUser(current)
                }
            }
        }
    }
    static let networkHelper = GGLUserNetworkHelper()
    static let userStatusSubject = PublishSubject<UserStatus>()

}

// MARK: - Request
extension GGLUser {

    static func signup(username: String, password: String, isSuper: Bool) {
        let _ = networkHelper.requestSignup(username: username, password: password, isSuper: isSuper).subscribe(onNext: { model in
            ProgressHUD.showServerMsg(model: model)
        })
    }

    static func login(username: String, password: String) {
        let _ = networkHelper.requestLogin(username: username, password: password).subscribe(onNext: { model in
            if model.code == .success,
               let user = model.data {
                current = user
                userStatusSubject.onNext(.login(user: user))
            }
            ProgressHUD.showServerMsg(model: model)
        })
    }

    static func login(userId: String) {
        let _ = networkHelper.requestLogin(userId: userId).subscribe(onNext: { model in
            if model.code == .success,
               let user = model.data {
                current = user
                userStatusSubject.onNext(.login(user: user))
            }
        })
    }

    static func logout() {
        guard let userId = GGLUser.getUserId() else { return }
        let _ = networkHelper.requestLogout(userId: userId).subscribe(onNext: { model in
            current = nil
            userStatusSubject.onNext(.logout)
            ProgressHUD.showServerMsg(model: model)
        })
    }

    static func forceLogout() {
        current = nil
        userStatusSubject.onNext(.forceLogout)
        ProgressHUD.showFailed("You have been forced to logout")
    }

    static func clearAll() {
        guard let userId = GGLUser.getUserId() else { return }
        let _ = networkHelper.requestClearAll(userId: userId).subscribe(onNext: { model in
            ProgressHUD.showServerMsg(model: model)
        })
    }

    static func getUser(userId: String) -> GGLUserModel? {
        if let systemUser = GGLSystemUser(rawValue: userId) {
            return GGLUserModel.create(userId: userId, userName: systemUser.name, avatarUrl: systemUser.avatar)
        }
        // TODO: - too much IO operation, use a cache list to optimize.
        let results = GGLDataBase.shared.objects(GGLUserModel.self).filter({ $0.userId == userId })
        if let target = results.first {
            return target
        }
        let userModel = GGLUserModel.create(userId: userId)
        GGLDataBase.shared.add(userModel)
        let _ = networkHelper.requestGetUser(userId: userId).observe(on: MainScheduler.instance).subscribe(onNext: { response in
            guard response.code == .success,
                  let newValue = response.data else { return }
            GGLDataBase.shared.saveOrUpdateUser(newValue)
        })
        return nil
    }

}

// MARK: - Method
extension GGLUser {

    static func getUserId(showHUD: Bool = true) -> String? {
        let userId = UserDefaults.userId
        if userId == nil, showHUD {
            ProgressHUD.showFailed("Please login")
        }
        return userId
    }

}

extension GGLUser {

    enum UserStatus {
        case login(user: GGLUserModel)
        case logout
        case forceLogout
    }

}
