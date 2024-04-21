//
//  GGLWSPeerMessageModel.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/21.
//

import Foundation

class GGLWSPeerMessageModel: GGLWebSocketModel {
    let contentType: ContentType?

    init(contentType: ContentType?, senderId: String?, targetId: String?) {
        self.contentType = contentType
        super.init(type: .peer_message, senderId: senderId, targetId: targetId)
    }

    required init(from decoder: any Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

final class GGLWSPeerTextModel: GGLWSPeerMessageModel {
    let text: String?

    init(text: String?, senderId: String?, targetId: String?) {
        self.text = text
        super.init(contentType: .text, senderId: senderId, targetId: targetId)
    }

    required init(from decoder: any Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

final class GGLWSPeerPhotoModel: GGLWSPeerMessageModel {
    let url: String?

    init(url: String?, senderId: String?, targetId: String?) {
        self.url = url
        super.init(contentType: .photo, senderId: senderId, targetId: targetId)
    }

    required init(from decoder: any Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

extension GGLWSPeerMessageModel {
    enum ContentType: String, Codable {
        case text
        case photo
    }
}
