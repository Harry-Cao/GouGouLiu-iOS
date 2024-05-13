//
//  GGLUserAPI.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/5/12.
//

import Foundation
import Moya

enum GGLUserAPI: TargetType {
    case signUp(username: String, password: String, isSuper: Bool)
    case login_n_pw(username: String, password: String)
    case login_id(userId: String)
    case logout(userId: String)
    case clearAll(userId: String)
    case allUsers(userId: String)
    case getUser(userId: String)

    var baseURL: URL {
        GGLAPI.baseURL
    }

    var path: String {
        switch self {
        case .signUp:
            return GGLAPI.Path.userSignup
        case .login_n_pw,
                .login_id:
            return GGLAPI.Path.userLogin
        case .logout:
            return GGLAPI.Path.userLogout
        case .clearAll:
            return GGLAPI.Path.userClearAll
        case .allUsers:
            return GGLAPI.Path.allUsers
        case .getUser:
            return GGLAPI.Path.getUser
        }
    }

    var method: Moya.Method {
        switch self {
        case .signUp,
                .login_n_pw,
                .login_id,
                .logout,
                .clearAll,
                .allUsers:
            return .post
        case .getUser:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .signUp(let username, let password, let isSuper):
            let para: [String: Any] = ["username": username, "password": password, "isSuper": isSuper]
            return .requestParameters(parameters: para, encoding: URLEncoding.default)
        case .login_n_pw(let username, let password):
            let para: [String: Any] = ["username": username, "password": password]
            return .requestParameters(parameters: para, encoding: URLEncoding.default)
        case .login_id(let userId):
            let para: [String: Any] = ["userId": userId]
            return .requestParameters(parameters: para, encoding: URLEncoding.default)
        case .logout(let userId):
            let para: [String: Any] = ["userId": userId]
            return .requestParameters(parameters: para, encoding: URLEncoding.default)
        case .clearAll(let userId):
            let para: [String: Any] = ["userId": userId]
            return .requestParameters(parameters: para, encoding: URLEncoding.default)
        case .allUsers(let userId):
            let para: [String: Any] = ["userId": userId]
            return .requestParameters(parameters: para, encoding: URLEncoding.default)
        case .getUser(let userId):
            let para: [String: Any] = ["userId": userId]
            return .requestParameters(parameters: para, encoding: URLEncoding.default)
        }
    }

    var headers: [String : String]? {
        nil
    }
}
