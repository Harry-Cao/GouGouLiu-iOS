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

    func requestSignup(username: String, password: String) -> Observable<GGLBaseMoyaModel> {
        let api = GGLUserSignupAPI(username: username, password: password)
        return Observable<GGLBaseMoyaModel>.ofRequest(api: api, provider: MoyaProvider<GGLUserSignupAPI>())
    }

    func requestLogin(username: String, password: String) -> Observable<GGLBaseMoyaModel> {
        let api = GGLUserLoginAPI(username: username, password: password)
        return Observable<GGLBaseMoyaModel>.ofRequest(api: api, provider: MoyaProvider<GGLUserLoginAPI>())
    }

    func requestLogout(userId: String) -> Observable<GGLBaseMoyaModel> {
        let api = GGLUserLogoutAPI(userId: userId)
        return Observable<GGLBaseMoyaModel>.ofRequest(api: api, provider: MoyaProvider<GGLUserLogoutAPI>())
    }

    func requestClearAll(userId: String) -> Observable<GGLBaseMoyaModel> {
        let api = GGLUserClearAllAPI(userId: userId)
        return Observable<GGLBaseMoyaModel>.ofRequest(api: api, provider: MoyaProvider<GGLUserClearAllAPI>())
    }

}
