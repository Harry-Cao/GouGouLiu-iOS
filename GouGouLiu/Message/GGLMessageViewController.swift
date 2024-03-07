//
//  GGLMessageViewController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/7.
//

import SwiftUI
import RealmSwift

final class GGLMessageViewController: GGLBaseHostingController<MessageContentView> {

    init() {
        _ = GGLDataBase.shared
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
//    private let messageModels: [GGLMessageModel] = [
//        GGLMessageModel(avatar: "http://f3.ttkt.cc:12873/GGLServer/media/global/dog.png", name: "狗狗溜客服", message: "您在使用过程中遇到任何问题都可以向我反馈"),
//        GGLMessageModel(type: .gemini, avatar: "http://f3.ttkt.cc:12873/GGLServer/media/global/pyy.jpeg", name: "Gemini", message: "Hi, I'm Gemini! A powerful chat bot for you.")
//    ]
//    @ObservedResults(GGLMessageModel.self) var messageModels
    let messageModels = GGLDataBase.shared.objects(GGLMessageModel.self)
    var body: some View {
        List(messageModels!) { model in
            Button {
                AppRouter.shared.push(GGLChatRoomViewController(messageModel: model))
            } label: {
                GGLMessageCell(messageModel: model)
            }
        }
        .listStyle(.plain)
    }
}
