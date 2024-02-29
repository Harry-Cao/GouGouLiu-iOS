//
//  GGLChatRoomViewController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/19.
//

import SwiftUI

final class GGLChatRoomViewController: GGLBaseHostingController<GGLChatRoomContentView> {
    init(messageModel: GGLMessageModel) {
        let viewModel = GGLChatRoomViewModel(messageModel: messageModel)
        super.init(rootView: GGLChatRoomContentView(viewModel: viewModel))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = rootView.viewModel.messageModel.name
    }
}

struct GGLChatRoomContentView: View {
    @ObservedObject var viewModel: GGLChatRoomViewModel

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.chatModels) { model in
                            GGLChatMessageAdapter(model: model)
                        }
                        if viewModel.responding {
                            GGLChatMessageAdapter(model: GGLChatTextModel(role: .other, content: viewModel.respondMessage, avatar: viewModel.messageModel.avatar))
                                .id(viewModel.respondId)
                        }
                    }
                    .onAppear(perform: {
                        guard let lastId = viewModel.chatModels.last?.id else { return }
                        proxy.scrollTo(lastId, anchor: .bottom)
                    })
                    .onChange(of: viewModel.chatModels) { _ in
                        withAnimation {
                            guard let lastId = viewModel.chatModels.last?.id else { return }
                            proxy.scrollTo(lastId, anchor: .bottom)
                        }
                    }
                    .onChange(of: viewModel.respondMessage) { _ in
                        withAnimation {
                            proxy.scrollTo(viewModel.respondId, anchor: .bottom)
                        }
                    }
                }
            }
            GGLChatRoomInputView(inputText: $viewModel.inputText, inputMode: viewModel.inputMode, sendDisabled: viewModel.sendDisabled) {
                viewModel.inputMode.toggle()
            } onClickSend: {
                viewModel.sendMessage()
            }
        }
        .onAppear(perform: {
            viewModel.geminiSayHi()
        })
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
