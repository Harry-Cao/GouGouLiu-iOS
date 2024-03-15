//
//  GGLAllUserAPI.swift
//  GouGouLiu
//
//  Created by Harry Cao on 3/14/24.
//

import Foundation
import Moya

struct GGLAllUserAPI: TargetType {

    var userId: String

    var baseURL: URL {
        GGLAPI.baseURL
    }

    var path: String {
        GGLAPI.allUsers
    }

    var method: Moya.Method {
        .post
    }

    var task: Moya.Task {
        var para: [String: Any] = [:]
        para.updateValue(userId, forKey: "userId")
        return .requestParameters(parameters: para, encoding: URLEncoding.queryString)
    }

    var headers: [String : String]? {
        nil
    }

}
