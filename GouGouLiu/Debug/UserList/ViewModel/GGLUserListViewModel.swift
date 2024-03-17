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
        guard let ownerId = GGLUser.getUserId(showHUD: false),
              let userId = model.userId else { return }
        let results = GGLDataBase.shared.objects(GGLMessageModel.self).filter("ownerId == %@ AND userId == %@", ownerId, userId)
        let messageModel: GGLMessageModel
        if let existMessageModel = results.first {
            messageModel = existMessageModel
        } else {
            let model = GGLMessageModel.create(ownerId: ownerId, userId: userId)
            GGLDataBase.shared.add(model)
            messageModel = model
        }
        GGLDataBase.shared.saveOrUpdateUser(model)
        AppRouter.shared.push(GGLChatRoomViewController(messageModel: messageModel))
    }
}
