//
//  GGLRtcViewModel.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/21.
//

import Foundation
import RxSwift

protocol GGLRtcViewModelDelegate: AnyObject {
    func needDismiss()
    func getDisposeBag() -> DisposeBag
}

final class GGLRtcViewModel: ObservableObject {
    static let shared = GGLRtcViewModel()
    weak var delegate: GGLRtcViewModelDelegate?
    private(set) var role: Role = .sender
    private(set) var type: GGLWSRtcMessageModel.RtcType = .voice
    private var channelId: String = ""
    private var targetId: String = ""
    private var userDataSubscriber: Disposable?
    @Published var targetUser: GGLUserModel?
    @Published var stage: Stage = .free
    lazy var localView = UIView()
    lazy var remoteView = UIView()

    func setup(role: Role,
               type: GGLWSRtcMessageModel.RtcType,
               channelId: String,
               targetId: String,
               delegate: GGLRtcViewModelDelegate?) {
        self.role = role
        self.type = type
        self.channelId = channelId
        self.targetId = targetId
        self.delegate = delegate
        subscribeData()
    }

    private func subscribeData() {
        userDataSubscriber = GGLDataBase.shared.userUpdateSubject.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] user in
            guard let self,
                  user.userId == targetId else { return }
            targetUser = user
            userDataSubscriber?.dispose()
        })
        if let disposeBag = delegate?.getDisposeBag() {
            GGLWebSocketManager.shared.messageSubject.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] model in
                guard let self,
                      model.type == .rtc_message,
                      let rtcModel = model as? GGLWSRtcMessageModel,
                      rtcModel.channelId == channelId,
                      let action = rtcModel.rtcAction else { return }
                switch action {
                case .invite:
                    stage = .holding
                case .accept:
                    GGLAgoraManager.shared.joinChannel(channelId: channelId)
                    stage = .talking
                case .reject:
                    stage = .free
                    delegate?.needDismiss()
                case .end:
                    GGLAgoraManager.shared.leaveChannel()
                    stage = .free
                    delegate?.needDismiss()
                }
            }).disposed(by: disposeBag)
        }
    }

    func onAppear() {
        getUserData()
        sendInvitation()
        setupAgora()
    }

    private func getUserData() {
        targetUser = GGLUser.getUser(userId: targetId)
        if let _ = targetUser {
            userDataSubscriber?.dispose()
        }
    }

    private func sendInvitation() {
        guard role == .sender else { return }
        stage = .holding
        GGLWebSocketManager.shared.sendRtcMessage(type: type, action: .invite, channelId: channelId, targetId: targetId)
    }

    private func setupAgora() {
        GGLAgoraManager.shared.setup()
        if type == .video {
            GGLAgoraManager.shared.setupVideoCanvas(localView: localView, remoteView: remoteView)
        }
    }

    func onDisappear() {
        GGLAgoraManager.shared.destroy()
    }

    func onClickCancelButton() {
        switch role {
        case .sender:
            switch stage {
            case .holding, .talking:
                GGLAgoraManager.shared.leaveChannel()
                GGLWebSocketManager.shared.sendRtcMessage(type: type, action: .end, channelId: channelId, targetId: targetId)
            case .free:
                break
            }
        case .receiver:
            switch stage {
            case .holding:
                GGLWebSocketManager.shared.sendRtcMessage(type: type, action: .reject, channelId: channelId, targetId: targetId)
            case .talking:
                GGLAgoraManager.shared.leaveChannel()
                GGLWebSocketManager.shared.sendRtcMessage(type: type, action: .end, channelId: channelId, targetId: targetId)
            case .free:
                break
            }
        }
        stage = .free
        delegate?.needDismiss()
    }

    func onClickConfirmButton() {
        GGLAgoraManager.shared.joinChannel(channelId: channelId)
        GGLWebSocketManager.shared.sendRtcMessage(type: type, action: .accept, channelId: channelId, targetId: targetId)
        stage = .talking
    }
}

extension GGLRtcViewModel {
    enum Role {
        case sender
        case receiver
    }
    enum Stage {
        case free
        case holding
        case talking
    }
}
