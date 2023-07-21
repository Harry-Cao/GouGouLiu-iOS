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
        .api_baseURL
    }

    var path: String {
        .path_userClearAll
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
