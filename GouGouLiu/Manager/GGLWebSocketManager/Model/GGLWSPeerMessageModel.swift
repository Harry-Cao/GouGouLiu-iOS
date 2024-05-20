//
//  GGLWSPeerMessageModel.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/21.
//

import Foundation

class GGLWSPeerMessageModel: GGLWebSocketModel {
    let contentType: ContentType?

    init(contentType: ContentType, senderId: String, targetId: String) {
        self.contentType = contentType
        super.init(type: .peer_message, senderId: senderId, targetId: targetId)
    }

    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        contentType = try container.decode(ContentType.self, forKey: .contentType)
        try super.init(from: decoder)
    }

    override func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(contentType, forKey: .contentType)
        try super.encode(to: encoder)
    }

    private enum CodingKeys: String, CodingKey {
        case contentType
    }
}

final class GGLWSPeerTextModel: GGLWSPeerMessageModel {
    let text: String?

    init(text: String, senderId: String, targetId: String) {
        self.text = text
        super.init(contentType: .text, senderId: senderId, targetId: targetId)
    }

    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decode(String.self, forKey: .text)
        try super.init(from: decoder)
    }

    override func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(text, forKey: .text)
        try super.encode(to: encoder)
    }

    private enum CodingKeys: String, CodingKey {
        case text
    }
}

final class GGLWSPeerPhotoModel: GGLWSPeerMessageModel {
    let url: String?

    init(url: String, senderId: String, targetId: String) {
        self.url = url
        super.init(contentType: .photo, senderId: senderId, targetId: targetId)
    }

    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decode(String.self, forKey: .photoUrl)
        try super.init(from: decoder)
    }

    override func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(url, forKey: .photoUrl)
        try super.encode(to: encoder)
    }

    private enum CodingKeys: String, CodingKey {
        case photoUrl
    }
}

extension GGLWSPeerMessageModel {
    enum ContentType: String, Codable {
        case text
        case photo
    }
}
