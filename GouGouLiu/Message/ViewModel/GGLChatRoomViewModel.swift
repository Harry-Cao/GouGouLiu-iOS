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

    @Published var inputMode: GGLChatInputMode = .text
    @Published var inputText: String = ""
    @Published var responding: Bool = false
    @Published var respondMessage: String = ""
    let respondId = UUID()
    var sendDisabled: Bool {
        return responding
    }

    func sendMessage() {
        guard !inputText.isEmpty else { return }
        let prompt = inputText
        inputText = ""
        let model = GGLChatModel.createText(role: .user, content: prompt, avatar: "http://f3.ttkt.cc:12873/GGLServer/media/global/cys.jpg")
        GGLDataBase.shared.insert(model, to: messageModel.messages)
        responding = true
        respondMessage = ""
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [self] timer in
            respondMessage.append("答复")
            if respondMessage.count > 20 {
                receivedAnswer()
                timer.invalidate()
            }
        }
    }

    private func receivedAnswer() {
        responding = false
        let model = GGLChatModel.createText(role: .other, content: respondMessage, avatar: messageModel.avatar)
        GGLDataBase.shared.insert(model, to: messageModel.messages)
    }
}
