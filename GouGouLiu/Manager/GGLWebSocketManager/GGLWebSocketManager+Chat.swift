//
//  GGLWebSocketManager+Chat.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/22.
//

import Foundation

extension GGLWebSocketManager {
    func sendPeerText(_ text: String, targetId: String) {
        guard let userId = GGLUser.getUserId(showHUD: false) else { return }
        let model = GGLWSPeerTextModel(text: text, senderId: userId, targetId: targetId)
        if let jsonString = GGLTool.modelToJsonString(model) {
            socket?.write(string: jsonString)
        }
    }

    func sendPeerPhoto(_ url: String, targetId: String) {
        guard let userId = GGLUser.getUserId(showHUD: false) else { return }
        let model = GGLWSPeerPhotoModel(url: url, senderId: userId, targetId: targetId)
        if let jsonString = GGLTool.modelToJsonString(model) {
            socket?.write(string: jsonString)
        }
    }
}
