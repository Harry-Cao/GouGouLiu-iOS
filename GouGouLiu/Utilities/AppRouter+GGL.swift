//
//  AppRouter+GGL.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/17.
//

import Foundation

extension AppRouter {

    func chat(user: GGLUserModel) {
        guard let ownerId = GGLUser.getUserId(showHUD: false),
              let userId = user.userId else { return }
        let messageModel: GGLMessageModel
        if let existMessageModel = GGLDataBase.shared.fetchMessageModel(ownerId: ownerId, userId: userId) {
            messageModel = existMessageModel
        } else {
            let model = GGLMessageModel.create(ownerId: ownerId, userId: userId)
            GGLDataBase.shared.addMessageModel(model)
            messageModel = model
        }
        GGLDataBase.shared.saveOrUpdateUser(user)
        push(GGLChatRoomViewController(messageModel: messageModel))
    }

}
