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
//    @ObservedResults(GGLMessageModel.self) var messageModels
    let messageModels = GGLDataBase.shared.objects(GGLMessageModel.self)
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
