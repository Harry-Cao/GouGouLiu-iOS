//
//  GGLWSRtcMessageModel.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/22.
//

import Foundation

final class GGLWSRtcMessageModel: GGLWebSocketModel {
    let rtcType: RtcType?
    let rtcAction: RtcAction?
    let channelId: String

    init(type: RtcType, action: RtcAction, channelId: String, senderId: String, targetId: String) {
        self.rtcType = type
        self.rtcAction = action
        self.channelId = channelId
        super.init(type: .rtc_message, senderId: senderId, targetId: targetId)
    }

    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        rtcType = try container.decode(RtcType.self, forKey: .rtcType)
        rtcAction = try container.decode(RtcAction.self, forKey: .rtcAction)
        channelId = try container.decode(String.self, forKey: .channelId)
        try super.init(from: decoder)
    }

    override func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(rtcType, forKey: .rtcType)
        try container.encode(rtcAction, forKey: .rtcAction)
        try container.encode(channelId, forKey: .channelId)
        try super.encode(to: encoder)
    }

    private enum CodingKeys: String, CodingKey {
        case rtcType
        case rtcAction
        case channelId
    }
}

extension GGLWSRtcMessageModel {
    enum RtcType: String, Codable {
        case voice
        case video
    }
    enum RtcAction: String, Codable {
        case invite
        case accept
        case reject
        case end
    }
}
