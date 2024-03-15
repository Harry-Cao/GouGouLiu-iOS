//
//  GGLMessageViewController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/7.
//

import SwiftUI

final class GGLMessageViewController: GGLBaseHostingController<MessageContentView> {

    init() {
        super.init(rootView: MessageContentView(viewModel: GGLMessageViewModel()))
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
    @ObservedObject var viewModel: GGLMessageViewModel

    var body: some View {
        List(viewModel.messageModels) { model in
            Button {
                AppRouter.shared.push(GGLChatRoomViewController(messageModel: model))
            } label: {
                GGLMessageCell(messageModel: model)
            }
        }
        .listStyle(.plain)
        .onAppear {
            viewModel.updateData()
        }
    }
}
