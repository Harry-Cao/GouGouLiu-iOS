//
//  GGLGetUserAPI.swift
//  GouGouLiu
//
//  Created by Harry Cao on 3/15/24.
//

import Foundation
import Moya

struct GGLGetUserAPI: TargetType {

    var userId: String

    var baseURL: URL {
        GGLAPI.baseURL
    }

    var path: String {
        GGLAPI.Path.getUser
    }

    var method: Moya.Method {
        .get
    }

    var task: Moya.Task {
        let para: [String: Any] = ["userId": userId]
        return .requestParameters(parameters: para, encoding: URLEncoding.default)
    }

    var headers: [String : String]? {
        nil
    }

}
