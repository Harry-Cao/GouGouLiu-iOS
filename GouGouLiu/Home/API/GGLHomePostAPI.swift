//
//  GGLHomePostAPI.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/7/5.
//

import Foundation
import Moya

struct GGLHomePostAPI: TargetType {

    var baseURL: URL {
        GGLAPI.baseURL
    }

    var path: String {
        "/api/post/all"
    }

    var method: Moya.Method {
        .get
    }

    var task: Moya.Task {
        .requestParameters(parameters: [:], encoding: URLEncoding.default)
    }

    var headers: [String : String]? {
        nil
    }

}
