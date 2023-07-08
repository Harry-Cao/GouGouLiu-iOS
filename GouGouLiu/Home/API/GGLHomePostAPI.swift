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
        .api_baseURL
    }

    var path: String {
        .path_homePageJson
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
