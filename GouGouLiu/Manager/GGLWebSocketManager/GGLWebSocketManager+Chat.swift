//
//  GGLWebSocketManager+Chat.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/22.
//

import Foundation

extension GGLWebSocketManager {
    func sendChatText(_ text: String, targetId: String) {
        guard let userId = GGLUser.getUserId(showHUD: false) else { return }
        let content = GGLWSChatTextModel(text: text)
        let model = GGLWebSocketModel(type: .peer_message, senderId: userId, targetId: targetId, content: content)
        if let jsonString = GGLTool.modelToJsonString(model) {
            socket?.write(string: jsonString)
        }
    }

    func sendChatPhoto(_ url: String, targetId: String) {
        guard let userId = GGLUser.getUserId(showHUD: false) else { return }
        let content = GGLWSChatPhotoModel(url: url)
        let model = GGLWebSocketModel(type: .peer_message, senderId: userId, targetId: targetId, content: content)
        if let jsonString = GGLTool.modelToJsonString(model) {
            socket?.write(string: jsonString)
        }
    }
}
