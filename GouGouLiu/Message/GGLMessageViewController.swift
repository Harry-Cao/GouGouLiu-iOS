//
//  GGLMessageViewController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/7.
//

import SwiftUI

final class GGLMessageViewController: GGLBaseHostingController<MessageContentView> {
    private let viewModel: GGLMessageViewModel

    init() {
        viewModel = GGLMessageViewModel()
        super.init(rootView: MessageContentView(viewModel: viewModel))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
    }

    private func bindData() {
        viewModel.$navigationTitle
            .receive(on: DispatchQueue.main)
            .assign(to: \.title, on: navigationItem)
            .store(in: &viewModel.cancellables)
    }
}

struct MessageContentView: View {
    @ObservedObject var viewModel: GGLMessageViewModel

    var body: some View {
        List {
            ForEach(viewModel.messageModels) { model in
                Button {
                    AppRouter.shared.push(GGLChatRoomViewController(messageModel: model))
                } label: {
                    GGLMessageCell(messageModel: model)
                }
                .deleteDisabled(viewModel.deleteDisabled(model: model))
            }
            .onDelete(perform: viewModel.onDelete(indexSet:))
        }
        .listStyle(.plain)
        .onAppear {
            viewModel.updateData()
        }
    }
}
