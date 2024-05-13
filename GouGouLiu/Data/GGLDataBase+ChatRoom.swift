//
//  GGLDataBase+ChatRoom.swift
//  GouGouLiu
//
//  Created by Harry Cao on 3/15/24.
//

import Foundation

extension GGLDataBase {
    func updateMessageModel(_ messageModel: GGLMessageModel) {
        userNetworkHelper.requestGetUser(userId: messageModel.userId) { [weak self] model in
            guard model.code == .success,
                  let newValue = model.data else { return }
            self?.saveOrUpdateUser(newValue)
        }
    }
}
