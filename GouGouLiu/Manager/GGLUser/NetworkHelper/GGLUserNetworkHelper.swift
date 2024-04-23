//
//  GGLUserNetworkHelper.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/21/23.
//

import Foundation
import RxSwift
import Moya

final class GGLUserNetworkHelper {

    func requestSignup(username: String, password: String, isSuper: Bool) -> Observable<GGLMoyaModel<GGLUserModel>> {
        let api = GGLUserSignupAPI(username: username, password: password, isSuper: isSuper)
        return MoyaProvider<GGLUserSignupAPI>().observable.request(api)
    }

    func requestLogin(username: String, password: String) -> Observable<GGLMoyaModel<GGLLoginModel>> {
        let api = GGLUserLoginAPI(username: username, password: password)
        return MoyaProvider<GGLUserLoginAPI>().observable.request(api)
    }

    func requestLogin(userId: String) -> Observable<GGLMoyaModel<GGLLoginModel>> {
        let api = GGLUserLoginAPI(userId: userId)
        return MoyaProvider<GGLUserLoginAPI>().observable.request(api)
    }

    func requestLogout(userId: String) -> Observable<GGLMoyaModel<GGLUserModel>> {
        let api = GGLUserLogoutAPI(userId: userId)
        return MoyaProvider<GGLUserLogoutAPI>().observable.request(api)
    }

    func requestClearAll(userId: String) -> Observable<GGLMoyaModel<GGLUserModel>> {
        let api = GGLUserClearAllAPI(userId: userId)
        return MoyaProvider<GGLUserClearAllAPI>().observable.request(api)
    }

    func requestAllUsers(userId: String) -> Observable<GGLMoyaModel<[GGLUserModel]>> {
        let api = GGLAllUserAPI(userId: userId)
        return MoyaProvider<GGLAllUserAPI>().observable.request(api)
    }

    func requestGetUser(userId: String) -> Observable<GGLMoyaModel<GGLUserModel>> {
        let api = GGLGetUserAPI(userId: userId)
        return MoyaProvider<GGLGetUserAPI>().observable.request(api)
    }

}
