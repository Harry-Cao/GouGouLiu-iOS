//
//  GGLUserClearAllAPI.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/22/23.
//

import Foundation
import Moya

struct GGLUserClearAllAPI: TargetType {

    var userId: String

    var baseURL: URL {
        GGLAPI.baseURL
    }

    var path: String {
        GGLAPI.userClearAll
    }

    var method: Moya.Method {
        .post
    }

    var task: Moya.Task {
        var para: [String: Any] = [:]
        para.updateValue(userId, forKey: "userId")
        return .requestParameters(parameters: para, encoding: URLEncoding.default)
    }

    var headers: [String : String]? {
        nil
    }

}
