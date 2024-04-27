//
//  GGLAgoraManager.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/20.
//

import AgoraRtcKit

final class GGLAgoraManager: NSObject {
    static let shared = GGLAgoraManager()
    private var agoraKit: AgoraRtcEngineKit?

    func setup() {
        let config = AgoraRtcEngineConfig()
        config.appId = "cc22839681b84eb3b1bec3052c475590"
        agoraKit = AgoraRtcEngineKit.sharedEngine(with: config, delegate: self)
    }

    func destroy() {
        agoraKit = nil
        AgoraRtcEngineKit.destroy()
    }

    func joinChannel(channelId: String) {
        guard let token = GGLKeychainHelper.userToken,
              let uid = GGLUser.getUserId() else { return }
        let option = AgoraRtcChannelMediaOptions()
        option.channelProfile = .liveBroadcasting
        option.clientRoleType = .broadcaster
        agoraKit?.joinChannel(byToken: token, channelId: channelId, userAccount: uid, mediaOptions: option)
    }

    func leaveChannel() {
        agoraKit?.stopPreview()
        agoraKit?.leaveChannel()
    }

    func setupVideoCanvas(localView: UIView, remoteView: UIView) {
        agoraKit?.enableVideo()
        agoraKit?.setupLocalVideo(videoCanvas(view: localView))
        agoraKit?.setupRemoteVideo(videoCanvas(view: remoteView))
        agoraKit?.startPreview()
    }

    private func videoCanvas(view: UIView) -> AgoraRtcVideoCanvas {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.view = view
        videoCanvas.renderMode = .hidden
        return videoCanvas
    }
}

// MARK: - AgoraRtcEngineDelegate
extension GGLAgoraManager: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit, connectionChangedTo state: AgoraConnectionState, reason: AgoraConnectionChangedReason) {
        switch state {
        case .connecting:
            print("connecting")
        case .reconnecting:
            print("reconnecting")
        case .connected:
            print("connected")
        case .disconnected:
            print("disconnected")
        case .failed:
            print("failed: \(reason)")
        default:
            break
        }
    }
}
