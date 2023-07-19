//
//  GGLClearAllPhotoAPI.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/19/23.
//

import Foundation
import Moya

struct GGLClearAllPhotoAPI: TargetType {

    var baseURL: URL {
        .api_baseURL
    }
    
    var path: String {
        .path_clearAllPhoto
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
