//
//  GGLWSMessageHelper.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/21.
//

import Foundation

struct GGLWSMessageHelper {
    static func handleWebSocketModel(_ model: GGLWebSocketModel) {
        guard let contentType = model.content?.type else { return }
        switch contentType {
        case .peer_chat:
            handlePeerChatMessage(model)
        case .peer_rtc:
            handlePeerRTCMessage(model)
        case .system_logout:
            GGLUser.forceLogout()
        }
    }
}

// MARK: - PeerMessage
extension GGLWSMessageHelper {
    private static func handlePeerChatMessage(_ model: GGLWebSocketModel) {
        guard let senderId = model.senderId,
              let ownerId = GGLUser.getUserId(showHUD: false),
              let chatModel = GGLWSMessageHelper.chatModelFromPeerMessage(model) else { return }
        let messageModel = GGLDataBase.shared.getMessageModel(ownerId: ownerId, userId: senderId)
        GGLDataBase.shared.insertChatModel(chatModel, to: messageModel)
        messageModelAddUnReadIfNeeded(messageModel: messageModel)
    }

    private static func chatModelFromPeerMessage(_ model: GGLWebSocketModel) -> GGLChatModel? {
        guard let content = model.content,
              let senderId = model.senderId else { return nil }
        switch content {
        case (let textModel as GGLWSChatTextModel):
            if let text = textModel.text {
                return GGLChatModel.createText(text, userId: senderId, createTime: model.createTime)
            }
        case (let photoModel as GGLWSChatPhotoModel):
            if let photoUrl = photoModel.url {
                return GGLChatModel.createPhoto(photoUrl, userId: senderId, createTime: model.createTime)
            }
        default:
            break
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
    static func handlePeerRTCMessage(_ model: GGLWebSocketModel) {
        guard let targetId = model.senderId,
              let content = model.content as? GGLWSRtcModel,
              !model.isOffline,
              let channelId = content.channelId,
              let rtcType = content.rtcType else { return }
        if GGLRtcViewModel.shared.stage == .free,
           content.rtcAction == .invite {
            let rtcViewController = GGLRtcViewController(role: .receiver, type: rtcType, channelId: channelId, targetId: targetId)
            AppRouter.shared.present(rtcViewController)
        }
    }
}
