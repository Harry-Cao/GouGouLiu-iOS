//
//  GGLChatRoomAPI.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/20.
//

import Moya

struct GGLChatRoomAPI: TargetType {
    let senderId: String
    let targetId: String

    var baseURL: URL {
        GGLAPI.baseURL
    }
    
    var path: String {
        "/api/chat/getChannelId"
    }
    
    var method: Moya.Method {
        .post
    }
    
    var task: Moya.Task {
        var para: [String: Any] = [:]
        para.updateValue(senderId, forKey: "senderId")
        para.updateValue(targetId, forKey: "targetId")
        return .requestParameters(parameters: para, encoding: JSONEncoding.default)
    }
    
    var headers: [String : String]? {
        nil
    }
}
