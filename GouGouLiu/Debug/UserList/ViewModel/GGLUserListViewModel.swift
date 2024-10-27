//
//  GGLUserListViewModel.swift
//  GouGouLiu
//
//  Created by Harry Cao on 3/14/24.
//

import SwiftUI

final class GGLUserListViewModel: ObservableObject {
    @Published private(set) var userModels: [GGLUserModel] = []
    private let networkHelper = GGLUserNetworkHelper()

    init() {
        requestAllUsers()
    }

    private func requestAllUsers() {
        networkHelper.requestAllUsers() { [weak self] model in
            if model.code == .success,
               let users = model.data {
                self?.userModels = users
            }
        }
    }

    func onClick(model: GGLUserModel) {
        AppRouter.shared.chat(user: model)
    }
}
