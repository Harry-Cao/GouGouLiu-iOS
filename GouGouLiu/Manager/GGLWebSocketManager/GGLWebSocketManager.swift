//
//  GGLWebSocketManager.swift
//  GouGouLiu
//
//  Created by Harry Cao on 3/13/24.
//

import Foundation
import Starscream
import Combine

final class GGLWebSocketManager {
    static let shared = GGLWebSocketManager()
    private(set) var socket: WebSocket?
    private(set) var messageSubject = PassthroughSubject<GGLWebSocketModel, Never>()
    private var cancellables = Set<AnyCancellable>()

    func startSubscribe() {
        subscribeUserStatus()
    }

    private func subscribeUserStatus() {
        GGLUser.userStatusSubject.sink { [weak self] status in
            switch status {
            case .login(let user):
                guard let userId = user.userId else { return }
                self?.connect(userId: userId)
            case .logout:
                self?.disconnect()
            case .forceLogout:
                break
            }
        }.store(in: &cancellables)
    }

    func connect(userId: String) {
        guard let basicAuthCredentials = userId.data(using: .utf8) else { return }
        let base64AuthCredentials = basicAuthCredentials.base64EncodedString()
        var request = URLRequest(url: URL(string: "ws://\(GGLAPI.host)\(GGLAPI.WS.chatGlobal)?\(base64AuthCredentials)")!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
    }

    func disconnect() {
        socket?.disconnect()
    }
}

// MARK: - WebSocketDelegate
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
        }
    }

    private func onReceivedText(_ text: String) {
        guard let model = GGLWSMessageHelper.parse(text: text) else { return }
        GGLWSMessageHelper.handleWebSocketModel(model)
        messageSubject.send(model)
    }
}
