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
    let content: GGLWSContentModel?
    var createTime: TimeInterval?
    var isOffline: Bool = false

    init(type: MessageType, senderId: String, targetId: String, content: GGLWSContentModel) {
        self.type = type
        self.senderId = senderId
        self.targetId = targetId
        self.content = content
    }

    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decodeIfPresent(GGLWebSocketModel.MessageType.self, forKey: .type)
        self.senderId = try container.decodeIfPresent(String.self, forKey: .senderId)
        self.targetId = try container.decodeIfPresent(String.self, forKey: .targetId)
        var content = try container.decodeIfPresent(GGLWSContentModel.self, forKey: .content)
        if let contentType = content?.type {
            switch contentType {
            case .peer_chat:
                let chatModel = try container.decodeIfPresent(GGLWSChatModel.self, forKey: .content)
                switch chatModel?.contentType {
                case .text:
                    content = try container.decodeIfPresent(GGLWSChatTextModel.self, forKey: .content)
                case .photo:
                    content = try container.decodeIfPresent(GGLWSChatPhotoModel.self, forKey: .content)
                case nil:
                    throw DecodingError.dataCorruptedError(forKey: .content, in: container, debugDescription: "Unknown peer chat type")
                }
            case .peer_rtc:
                content = try container.decodeIfPresent(GGLWSRtcModel.self, forKey: .content)
            case .system_logout:
                break
            }
        }
        self.content = content
        self.createTime = try container.decodeIfPresent(TimeInterval.self, forKey: .createTime)
        self.isOffline = try container.decode(Bool.self, forKey: .isOffline)
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.type, forKey: .type)
        try container.encodeIfPresent(self.senderId, forKey: .senderId)
        try container.encodeIfPresent(self.targetId, forKey: .targetId)
        try container.encodeIfPresent(self.content, forKey: .content)
        try container.encodeIfPresent(self.createTime, forKey: .createTime)
        try container.encode(self.isOffline, forKey: .isOffline)
    }

    enum CodingKeys: CodingKey {
        case type
        case senderId
        case targetId
        case content
        case createTime
        case isOffline
    }
}

extension GGLWebSocketModel {
    enum MessageType: String, Codable {
        case peer_message
        case system_message
    }
}
