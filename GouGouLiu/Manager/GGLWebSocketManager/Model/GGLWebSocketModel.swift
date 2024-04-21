//
//  GGLWebSocketModel.swift
//  GouGouLiu
//
//  Created by Harry Cao on 3/14/24.
//

import Foundation

class GGLWebSocketModel: Codable {
    let type: MessageType?
    let senderId: String?
    let targetId: String?

    init(type: MessageType?, senderId: String?, targetId: String?) {
        self.type = type
        self.senderId = senderId
        self.targetId = targetId
    }
}

extension GGLWebSocketModel {
    enum MessageType: String, Codable {
        case peer_message
        case system_logout
    }
}
