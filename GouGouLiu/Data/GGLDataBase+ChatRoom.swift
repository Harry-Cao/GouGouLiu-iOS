//
//  GGLDataBase+ChatRoom.swift
//  GouGouLiu
//
//  Created by Harry Cao on 3/15/24.
//

import RxSwift

extension GGLDataBase {
    func updateMessageModel(_ messageModel: GGLMessageModel) {
        let networkHelper = GGLUserNetworkHelper()
        let _ = networkHelper.requestGetUser(userId: messageModel.userId).observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] response in
            guard response.code == .success,
                  let newValue = response.data else { return }
            self?.saveOrUpdateUser(newValue)
        })
    }
}
