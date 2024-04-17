//
//  GGLUserListViewModel.swift
//  GouGouLiu
//
//  Created by Harry Cao on 3/14/24.
//

import SwiftUI
import RxSwift

final class GGLUserListViewModel: ObservableObject {
    @Published var userModels: [GGLUserModel] = []

    init() {
        requestAllUsers()
    }

    private func requestAllUsers() {
        guard let userId = GGLUser.getUserId() else { return }
        let networkHelper = GGLUserNetworkHelper()
        let _ = networkHelper.requestAllUsers(userId: userId).observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] response in
            if response.code == .success,
               let users = response.data {
                self?.userModels = users
            }
            ProgressHUD.showServerMsg(model: response)
        })
    }

    func onClick(model: GGLUserModel) {
        AppRouter.shared.chat(user: model)
    }
}
