//
//  GGLUserLoginAPI.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/21/23.
//

import Foundation
import Moya

struct GGLUserLoginAPI: TargetType {

    var username: String?
    var password: String?
    var userId: String?

    var baseURL: URL {
        GGLAPI.baseURL
    }

    var path: String {
        GGLAPI.Path.userLogin
    }

    var method: Moya.Method {
        .post
    }

    var task: Moya.Task {
        var para: [String: Any] = [:]
        para["username"] = username
        para["password"] = password
        para["userId"] = userId
        return .requestParameters(parameters: para, encoding: URLEncoding.default)
    }

    var headers: [String : String]? {
        nil
    }

}
