//
//  GGLWebSocketManager.swift
//  GouGouLiu
//
//  Created by Harry Cao on 3/13/24.
//

import Foundation
import Starscream
import RxSwift

final class GGLWebSocketManager {
    static let shared = GGLWebSocketManager()
    private var socket: WebSocket?
    private var userId: String?
    private(set) var messageSubject = PublishSubject<GGLWebSocketModel>()
    private let disposeBag = DisposeBag()

    func startSubscribe() {
        subscribeUserStatus()
    }

    private func subscribeUserStatus() {
        GGLUser.userStatusSubject.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] status in
            switch status {
            case .login(let user):
                guard let userId = user.userId else { return }
                self?.connect(userId: userId)
            case .logout:
                self?.disconnect()
            }
        }).disposed(by: disposeBag)
    }

    func connect(userId: String) {
        self.userId = userId
        guard let basicAuthCredentials = userId.data(using: .utf8) else { return }
        let base64AuthCredentials = basicAuthCredentials.base64EncodedString()
        var request = URLRequest(url: URL(string: "ws://\(GGLAPI.host)\(GGLAPI.chatGlobal)?\(base64AuthCredentials)")!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
    }

    func disconnect() {
        socket?.disconnect()
    }

    func sendPeerMessage(_ message: String, targetId: String) {
        guard let userId else { return }
        let model = GGLWebSocketModel(type: .peer_message, senderId: userId, targetId: targetId, message: message)
        if let jsonString = GGLTool.modelToJsonString(model) {
            socket?.write(string: jsonString)
        }
    }

    private func onReceivedText(_ text: String) {
        guard let model = GGLTool.jsonStringToModel(jsonString: text, to: GGLWebSocketModel.self) else { return }
        messageSubject.onNext(model)
    }
}

extension GGLWebSocketManager: WebSocketDelegate {
    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocketClient) {
        switch event {
        case .connected(let headers):
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            onReceivedText(string)
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            print("cancelled")
        case .error(let error):
            print(error as Any)
        case .peerClosed:
            print("peerClosed")
            break
        }
    }
}
