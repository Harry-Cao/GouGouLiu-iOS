//
//  GGLWebSocketManager+RTC.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/22.
//

import Foundation

extension GGLWebSocketManager {
    func sendRtcMessage(type: GGLWSRtcMessageModel.RtcType, action: GGLWSRtcMessageModel.RtcAction, channelId: String, targetId: String) {
        guard let userId = GGLUser.getUserId(showHUD: false) else { return }
        let model = GGLWSRtcMessageModel(type: type, action: action, channelId: channelId, senderId: userId, targetId: targetId)
        if let jsonString = GGLTool.modelToJsonString(model) {
            socket?.write(string: jsonString)
        }
    }
}
