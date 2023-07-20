//
//  GGLUserSignupAPI.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/21/23.
//

import Foundation
import Moya

struct GGLUserSignupAPI: TargetType {

    var username: String
    var password: String

    var baseURL: URL {
        .api_baseURL
    }

    var path: String {
        .path_userSignup
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
