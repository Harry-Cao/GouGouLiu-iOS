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

    static func handleWebSocketModel(_ model: GGLWebSocketModel) {
        guard let type = model.type else { return }
        switch type {
        case .peer_message:
            guard let peerMessage = model as? GGLWSPeerMessageModel else { return }
            handlePeerMessage(peerMessage)
        case .system_logout:
            GGLUser.forceLogout()
        case .rtc_message:
            guard let rtcMessageModel = model as? GGLWSRtcMessageModel else { return }
            handleRTCMessage(rtcMessageModel)
        }
    }
}

// MARK: - PeerMessage
extension GGLWSMessageHelper {
    private static func handlePeerMessage(_ peerMessage: GGLWSPeerMessageModel) {
        guard let senderId = peerMessage.senderId,
              let ownerId = GGLUser.getUserId(showHUD: false),
              let chatModel = GGLWSMessageHelper.chatModelFromPeerMessage(peerMessage) else { return }
        let messageModel = GGLDataBase.shared.getMessageModel(ownerId: ownerId, userId: senderId)
        GGLDataBase.shared.insertChatModel(chatModel, to: messageModel)
        messageModelAddUnReadIfNeeded(messageModel: messageModel)
    }

    private static func chatModelFromPeerMessage(_ peerMessage: GGLWSPeerMessageModel) -> GGLChatModel? {
        guard let contentType = peerMessage.contentType,
              let senderId = peerMessage.senderId else { return nil }
        switch contentType {
        case .text:
            if let textModel = peerMessage as? GGLWSPeerTextModel,
               let text = textModel.text {
                return GGLChatModel.createText(text, userId: senderId)
            }
        case .photo:
            if let photoModel = peerMessage as? GGLWSPeerPhotoModel,
               let photoUrl = photoModel.url {
                return GGLChatModel.createPhoto(photoUrl, userId: senderId)
            }
        }
        return nil
    }

    private static func messageModelAddUnReadIfNeeded(messageModel: GGLMessageModel) {
        if let topViewController = GGLTool.topViewController,
           let chatRoomViewController = topViewController as? GGLChatRoomViewController,
           chatRoomViewController.rootView.viewModel.messageModel.userId == messageModel.userId {
            return
        }
        GGLDataBase.shared.addUnRead(messageModel: messageModel)
    }
}

// MARK: - RTCMessage
extension GGLWSMessageHelper {
    static func handleRTCMessage(_ rtcMessage: GGLWSRtcMessageModel) {
        guard let rtcType = rtcMessage.rtcType,
              let targetId = rtcMessage.senderId else { return }
        if GGLRtcViewModel.shared.stage == .free,
           rtcMessage.rtcAction == .invite {
            let rtcViewController = GGLRtcViewController(role: .receiver, type: rtcType, channelId: rtcMessage.channelId, targetId: targetId)
            AppRouter.shared.present(rtcViewController)
        }
    }
}
