//
//  GGLClearAllPhotoAPI.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/19/23.
//

import Foundation
import Moya

struct GGLClearAllPhotoAPI: TargetType {

    var userId: String

    var baseURL: URL {
        .api_baseURL
    }
    
    var path: String {
        .path_clearAllPhoto
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
