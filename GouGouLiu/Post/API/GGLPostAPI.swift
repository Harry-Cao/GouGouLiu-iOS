//
//  GGLPostAPI.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/24/23.
//

import Foundation
import Moya

struct GGLPostAPI: TargetType {

    var userId: String
    var coverUrl: String
    var imageUrls: [String]
    var title: String
    var content: String?

    var baseURL: URL {
        .api_baseURL
    }

    var path: String {
        .path_publishPost
    }

    var method: Moya.Method {
        .post
    }

    var task: Moya.Task {
        var para: [String: Any] = [:]
        para["userId"] = userId
        para["coverUrl"] = coverUrl
        para["imageUrls"] = imageUrls
        para["title"] = title
        para["content"] = content
        return .requestParameters(parameters: para, encoding: JSONEncoding.default)
    }

    var headers: [String : String]? {
        nil
    }

}
