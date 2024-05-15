//
//  GGLAgoraManager.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/20.
//

import AgoraRtcKit

protocol GGLAgoraManagerDelegate: AnyObject {
    func onRemoteJoined(uid: UInt) -> UIView
}

final class GGLAgoraManager: NSObject {
    static let shared = GGLAgoraManager()
    private var agoraKit: AgoraRtcEngineKit?
    weak var delegate: GGLAgoraManagerDelegate?

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
        let options = AgoraRtcChannelMediaOptions()
        options.channelProfile = .liveBroadcasting
        options.clientRoleType = .broadcaster
        agoraKit?.joinChannel(byToken: token, channelId: channelId, userAccount: uid, mediaOptions: options)
    }

    func leaveChannel() {
        agoraKit?.stopPreview()
        agoraKit?.leaveChannel()
    }

    func setupVideoCanvas(localView: UIView, delegate: GGLAgoraManagerDelegate) {
        self.delegate = delegate
        agoraKit?.enableVideo()
        agoraKit?.setupLocalVideo(videoCanvas(view: localView))
        agoraKit?.startPreview()
    }

    private func videoCanvas(view: UIView, uid: UInt? = nil) -> AgoraRtcVideoCanvas {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.view = view
        videoCanvas.renderMode = .hidden
        videoCanvas.uid = uid ?? 0
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

    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        guard let remoteView = delegate?.onRemoteJoined(uid: uid) else { return }
        agoraKit?.setupRemoteVideo(videoCanvas(view: remoteView, uid: uid))
    }
}
