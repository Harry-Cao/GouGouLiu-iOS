//
//  GGLDataBase+Message.swift
//  GouGouLiu
//
//  Created by Harry Cao on 3/8/24.
//

import Foundation

extension GGLDataBase {
    static func setupBaseMessagesIfNeeded() {
        let results = GGLDataBase.shared.objects(GGLMessageModel.self)
        guard results.isEmpty else { return }
        let clientObject = GGLMessageModel.create(avatar: "http://f3.ttkt.cc:12873/GGLServer/media/global/dog.png", name: "狗狗溜客服")
        GGLDataBase.shared.add(clientObject)
        GGLDataBase.shared.insert(GGLChatModel.createText(role: .other, content: "您在使用过程中遇到任何问题都可以向我反馈", avatar: clientObject.avatar), to: clientObject.messages)
        let geminiObject = GGLMessageModel.create(type: .gemini, avatar: "http://f3.ttkt.cc:12873/GGLServer/media/global/pyy.jpeg", name: "Gemini")
        GGLDataBase.shared.add(geminiObject)
        GGLDataBase.shared.insert(GGLChatModel.createText(role: .other, content: "Hi, I'm Gemini! A powerful chat bot for you.", avatar: geminiObject.avatar), to: geminiObject.messages)
    }
}
