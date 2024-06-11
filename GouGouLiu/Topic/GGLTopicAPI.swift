//
//  GGLTopicAPI.swift
//  GouGouLiu
//
//  Created by Harry Cao on 8/16/23.
//

import Foundation
import Moya

struct GGLTopicAPI: TargetType {

    var postId: String

    var baseURL: URL {
        GGLAPI.baseURL
    }

    var path: String {
        GGLAPI.Path.searchPost
    }

    var method: Moya.Method {
        .get
    }

    var task: Moya.Task {
        var para: [String: Any] = [:]
        para["postId"] = postId
        return .requestParameters(parameters: para, encoding: URLEncoding.default)
    }

    var headers: [String : String]? {
        nil
    }

}
