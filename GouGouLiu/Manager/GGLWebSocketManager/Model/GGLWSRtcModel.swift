//
//  GGLWSRtcModel.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/22.
//

import Foundation

final class GGLWSRtcModel: GGLWSContentModel {
    let rtcType: RtcType?
    let rtcAction: RtcAction?
    let channelId: String?

    init(type: RtcType, action: RtcAction, channelId: String) {
        self.rtcType = type
        self.rtcAction = action
        self.channelId = channelId
        super.init(type: .peer_rtc)
    }

    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        rtcType = try container.decodeIfPresent(RtcType.self, forKey: .rtcType)
        rtcAction = try container.decodeIfPresent(RtcAction.self, forKey: .rtcAction)
        channelId = try container.decodeIfPresent(String.self, forKey: .channelId)
        try super.init(from: decoder)
    }

    override func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(rtcType, forKey: .rtcType)
        try container.encodeIfPresent(rtcAction, forKey: .rtcAction)
        try container.encodeIfPresent(channelId, forKey: .channelId)
        try super.encode(to: encoder)
    }

    private enum CodingKeys: String, CodingKey {
        case rtcType
        case rtcAction
        case channelId
    }
}

extension GGLWSRtcModel {
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
