//
//  GGLRtcViewModel.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/21.
//

import Foundation
import RxSwift

final class GGLRtcViewModel: ObservableObject {
    var stage: Stage = .holding
    private let role: Role
    private let channelId: String
    private let targetId: String
    @Published var targetUser: GGLUserModel?
    private var userDataSubscriber: Disposable?
    private let disposeBag = DisposeBag()

    init(role: Role, channelId: String, targetId: String) {
        self.role = role
        self.channelId = channelId
        self.targetId = targetId
        subscribeData()
    }

    private func subscribeData() {
        userDataSubscriber = GGLDataBase.shared.userUpdateSubject.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] user in
            guard let self, user.userId == targetId else { return }
            targetUser = user
            userDataSubscriber?.dispose()
        })
        GGLWebSocketManager.shared.messageSubject.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] model in
            guard let self else { return }
            
        }).disposed(by: disposeBag)
    }

    func onAppear() {
        getUserData()
        if role == .sender {
            // 通过websocket发送通话邀请
        }
    }

    private func getUserData() {
        targetUser = GGLUser.getUser(userId: targetId)
    }
}

extension GGLRtcViewModel {
    enum Role {
        case sender
        case receiver
    }
    enum Stage {
        case holding
        case talking
        case ended
    }
}
