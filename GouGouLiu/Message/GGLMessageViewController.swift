//
//  GGLMessageViewController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/7.
//

import SwiftUI

final class GGLMessageViewController: GGLBaseHostingController<MessageContentView> {

    init() {
        super.init(rootView: MessageContentView())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = .Message
    }

}

struct MessageContentView: View {
    var messageModels: [GGLMessageModel] = [
        GGLMessageModel(type: .gemini, avatar: "http://f3.ttkt.cc:12873/GGLServer/media/global/pyy.jpeg", name: "Gemini", message: "Hi, I'm Gemini! A powerful chat bot for you.")
    ]
    var body: some View {
        List(messageModels) { model in
            Button {
                AppRouter.shared.push(GGLChatRoomViewController(messageModel: model))
            } label: {
                GGLMessageCell(messageModel: model)
            }
        }
        .listStyle(.plain)
    }
}
