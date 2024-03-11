//
//  GGLUserLoginAPI.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/21/23.
//

import Foundation
import Moya

struct GGLUserLoginAPI: TargetType {

    var username: String
    var password: String

    var baseURL: URL {
        GGLAPI.baseURL
    }

    var path: String {
        GGLAPI.userLogin
    }

    var method: Moya.Method {
        .post
    }

    var task: Moya.Task {
        var para: [String: Any] = [:]
        para.updateValue(username, forKey: "username")
        para.updateValue(password, forKey: "password")
        return .requestParameters(parameters: para, encoding: URLEncoding.queryString)
    }

    var headers: [String : String]? {
        nil
    }

}
