//
//  GGLUserListViewModel.swift
//  GouGouLiu
//
//  Created by Harry Cao on 3/14/24.
//

import SwiftUI

final class GGLUserListViewModel: ObservableObject {
    @Published var userModels: [GGLUserModel] = []
    private let networkHelper = GGLUserNetworkHelper()

    init() {
        requestAllUsers()
    }

    private func requestAllUsers() {
        guard let userId = GGLUser.getUserId() else { return }
        networkHelper.requestAllUsers(userId: userId) { [weak self] model in
            if model.code == .success,
               let users = model.data {
                self?.userModels = users
            }
            ProgressHUD.showServerMsg(model: model)
        }
    }

    func onClick(model: GGLUserModel) {
        AppRouter.shared.chat(user: model)
    }
}
