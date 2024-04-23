//
//  GGLWSMessageHelper.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/21.
//

import Foundation

struct GGLWSMessageHelper {
    static func parse(text: String) -> GGLWebSocketModel? {
        guard let model = GGLTool.jsonStringToModel(jsonString: text, to: GGLWebSocketModel.self),
              let type = model.type else { return nil }
        switch type {
        case .peer_message:
            guard let peerMessage = GGLTool.jsonStringToModel(jsonString: text, to: GGLWSPeerMessageModel.self),
                  let contentType = peerMessage.contentType else { return nil }
            switch contentType {
            case .text:
                return GGLTool.jsonStringToModel(jsonString: text, to: GGLWSPeerTextModel.self)
            case .photo:
                return GGLTool.jsonStringToModel(jsonString: text, to: GGLWSPeerPhotoModel.self)
            }
        case .system_logout:
            return model
        case .rtc_message:
            return GGLTool.jsonStringToModel(jsonString: text, to: GGLWSRtcMessageModel.self)
        }
    }
}
