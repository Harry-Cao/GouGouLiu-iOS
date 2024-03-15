//
//  GGLUserListViewController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 3/14/24.
//

import SwiftUI

final class GGLUserListViewController: GGLBaseHostingController<UserListContentView> {
    init() {
        super.init(rootView: UserListContentView(viewModel: GGLUserListViewModel()))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct UserListContentView: View {
    @ObservedObject var viewModel: GGLUserListViewModel
    var body: some View {
        List(viewModel.userModels, id: \.self) { model in
            Button {
                viewModel.onClick(model: model)
            } label: {
                GGLUserListCell(userModel: model)
            }
        }
        .listStyle(.plain)
    }
}
