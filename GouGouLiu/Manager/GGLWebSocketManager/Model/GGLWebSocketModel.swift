//
//  GGLWebSocketModel.swift
//  GouGouLiu
//
//  Created by Harry Cao on 3/14/24.
//

import Foundation

struct GGLWebSocketModel: Codable {
    let type: MessageType?
    let senderId: String?
    let targetId: String?
    let contentType: ContentType?

    var message: String?
    var photoUrl: String?
}

extension GGLWebSocketModel {
    enum MessageType: String, Codable {
        case peer_message
        case system_logout
    }
    enum ContentType: String, Codable {
        case text
        case photo
    }
}
