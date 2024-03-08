//
//  GGLMessageViewController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/7.
//

import SwiftUI

final class GGLMessageViewController: GGLBaseHostingController<MessageContentView> {

    init() {
        GGLDataBase.setupBaseMessagesIfNeeded()
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
    @State var messageModels: [GGLMessageModel] = []
    var body: some View {
        List(messageModels) { model in
            Button {
                AppRouter.shared.push(GGLChatRoomViewController(messageModel: model))
            } label: {
                GGLMessageCell(messageModel: model)
            }
        }
        .listStyle(.plain)
        .onAppear {
            messageModels = GGLDataBase.shared.objects(GGLMessageModel.self).sorted(by: { model1, model2 in
                model1.messages.last?.time ?? Date() > model2.messages.last?.time ?? Date()
            })
        }
    }
}
