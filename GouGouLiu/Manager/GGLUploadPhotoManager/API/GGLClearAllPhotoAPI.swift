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
        GGLAPI.baseURL
    }
    
    var path: String {
        GGLAPI.clearAllPhoto
    }
    
    var method: Moya.Method {
        .post
    }
    
    var task: Moya.Task {
        var para: [String: Any] = [:]
        para.updateValue(userId, forKey: "userId")
        return .requestParameters(parameters: para, encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        nil
    }

}
