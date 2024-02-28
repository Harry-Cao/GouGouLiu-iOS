//
//  GGLChatRoomViewModel.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2/27/24.
//

import SwiftUI

final class GGLChatRoomViewModel: ObservableObject {
    let messageModel: GGLMessageModel
    init(messageModel: GGLMessageModel) {
        self.messageModel = messageModel
    }

    @Published var chatModels: [GGLChatBaseModel] = []
    @Published var inputMode: GGLChatInputMode = .text
    @Published var inputText: String = ""
    @Published var responding: Bool = false
    @Published var respondMessage: String = ""
    var sendDisabled: Bool {
        return responding
    }

    func geminiSayHi() {
        guard messageModel.type == .gemini else { return }
        chatModels.append(GGLChatTextModel(role: .other, content: "hi", avatar: messageModel.avatar))
    }

    func sendMessage() {
        guard !inputText.isEmpty else { return }
        chatModels.append(GGLChatTextModel(role: .user, content: inputText, avatar: "http://f3.ttkt.cc:12873/GGLServer/media/global/cys.jpg"))
        responding = true
        respondMessage = "收到问题：\(inputText)\n"
        inputText = ""
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [self] timer in
            respondMessage.append("答复")
            if respondMessage.count > 20 {
                responding = false
                chatModels.append(GGLChatTextModel(role: .other, content: respondMessage, avatar: messageModel.avatar))
                timer.invalidate()
            }
        }
    }
}
