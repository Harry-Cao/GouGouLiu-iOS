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
        "/api/post/\(postId)"
    }

    var method: Moya.Method {
        .get
    }

    var task: Moya.Task {
        return .requestPlain
    }

    var headers: [String : String]? {
        nil
    }

}
