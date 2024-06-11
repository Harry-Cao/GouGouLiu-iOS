//
//  GGLWSContentModel.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/6/5.
//

import Foundation

class GGLWSContentModel: Codable {
    let type: ContentType?

    init(type: ContentType?) {
        self.type = type
    }
}

extension GGLWSContentModel {
    enum ContentType: String, Codable {
        case peer_chat
        case peer_rtc
        case system_logout
    }
}
