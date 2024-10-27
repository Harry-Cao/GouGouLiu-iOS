//
//  GGLPublishAPI.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/24/23.
//

import Foundation
import Moya

enum GGLPublishAPI: TargetType {
    case publishPost(userId: String, coverUrl: String, photoIDs: [UInt], title: String, content: String?)
    case clearAll(userId: String)

    var baseURL: URL {
        GGLAPI.baseURL
    }

    var path: String {
        switch self {
        case .publishPost:
            return "/api/post/publish"
        case .clearAll:
            return "/api/post/clearAll"
        }
    }

    var method: Moya.Method {
        .post
    }

    var task: Moya.Task {
        switch self {
        case .publishPost(let userId, let coverUrl, let photoIDs, let title, let content):
            var para: [String: Any] = [:]
            para["userId"] = userId
            para["coverUrl"] = coverUrl
            para["photoIds"] = photoIDs
            para["title"] = title
            para["content"] = content
            return .requestParameters(parameters: para, encoding: JSONEncoding.default)
        case .clearAll(let userId):
            let para: [String: Any] = ["userId": userId]
            return .requestParameters(parameters: para, encoding: JSONEncoding.default)
        }
    }

    var headers: [String : String]? {
        nil
    }
}
