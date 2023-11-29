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

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = .Message
        setupRightBarButtonItems()
    }

    private func setupRightBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(didTapRefresh))
    }

    @objc private func didTapRefresh() {
        rootView.messageModels.append(MessageModel(name: "Tom", message: "Hi Ben! Here is a great news for you, please check this message before dinner."))
    }

}

struct MessageContentView: View {
    var messageModels: [MessageModel] = [
        MessageModel(name: "Tom", message: "Hi Ben! Here is a great news for you, please check this message before dinner.")
    ]
    var body: some View {
        List(messageModels) { model in
            Button {
                AppRouter.shared.push(GGLChatRoomViewController())
            } label: {
                MessageCell(messageModel: model)
            }
        }
        .listStyle(.plain)
    }
}

struct GGLMessagePreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        MessageContentView(messageModels: [
            MessageModel(name: "Tom", message: "Hi Ben! Here is a great news for you, please check this message before dinner.")
        ])
    }
}
