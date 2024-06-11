//
//  GGLWebSocketManager+RTC.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/22.
//

import Foundation

extension GGLWebSocketManager {
    func sendRtcMessage(type: GGLWSRtcModel.RtcType, action: GGLWSRtcModel.RtcAction, channelId: String, targetId: String) {
        guard let userId = GGLUser.getUserId(showHUD: false) else { return }
        let content = GGLWSRtcModel(type: type, action: action, channelId: channelId)
        let model = GGLWebSocketModel(type: .peer_message, senderId: userId, targetId: targetId, content: content)
        if let jsonString = GGLTool.modelToJsonString(model) {
            socket?.write(string: jsonString)
        }
    }
}
