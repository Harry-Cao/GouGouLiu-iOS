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
        .api_baseURL
    }

    var path: String {
        .path_searchPost
    }

    var method: Moya.Method {
        .post
    }

    var task: Moya.Task {
        var para: [String: Any] = [:]
        para["postId"] = postId
        return .requestParameters(parameters: para, encoding: URLEncoding.queryString)
    }

    var headers: [String : String]? {
        nil
    }

}
