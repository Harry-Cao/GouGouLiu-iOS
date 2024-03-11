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
        GGLAPI.homePagePost
    }

    var method: Moya.Method {
        .get
    }

    var task: Moya.Task {
        .requestParameters(parameters: [:], encoding: URLEncoding.queryString)
    }

    var headers: [String : String]? {
        nil
    }

}
