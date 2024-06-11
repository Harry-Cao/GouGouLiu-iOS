//
//  GGLWSChatModel.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/21.
//

import Foundation

class GGLWSChatModel: GGLWSContentModel {
    let contentType: ContentType?

    init(contentType: ContentType) {
        self.contentType = contentType
        super.init(type: .peer_chat)
    }

    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        contentType = try container.decodeIfPresent(ContentType.self, forKey: .contentType)
        try super.init(from: decoder)
    }

    override func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(contentType, forKey: .contentType)
        try super.encode(to: encoder)
    }

    private enum CodingKeys: String, CodingKey {
        case contentType
    }
}

final class GGLWSChatTextModel: GGLWSChatModel {
    let text: String?

    init(text: String) {
        self.text = text
        super.init(contentType: .text)
    }

    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decodeIfPresent(String.self, forKey: .text)
        try super.init(from: decoder)
    }

    override func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(text, forKey: .text)
        try super.encode(to: encoder)
    }

    private enum CodingKeys: String, CodingKey {
        case text
    }
}

final class GGLWSChatPhotoModel: GGLWSChatModel {
    let url: String?

    init(url: String) {
        self.url = url
        super.init(contentType: .photo)
    }

    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        try super.init(from: decoder)
    }

    override func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(url, forKey: .photoUrl)
        try super.encode(to: encoder)
    }

    private enum CodingKeys: String, CodingKey {
        case photoUrl
    }
}

extension GGLWSChatModel {
    enum ContentType: String, Codable {
        case text
        case photo
    }
}
