//
//  GGLWebSocketModel.swift
//  GouGouLiu
//
//  Created by Harry Cao on 3/14/24.
//

import Foundation

struct GGLWebSocketModel: Codable {
    var type: MessageType?
    var senderId: String?
    var targetId: String?
    var message: String?
}

extension GGLWebSocketModel {
    enum MessageType: String, Codable {
        case peer_message = "peer_message"
    }
}
