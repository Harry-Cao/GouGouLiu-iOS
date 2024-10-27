//
//  GGLWebSocketManager.swift
//  GouGouLiu
//
//  Created by Harry Cao on 3/13/24.
//

import Foundation
import Starscream
import Combine
import OSLog

final class GGLWebSocketManager {
    static let shared = GGLWebSocketManager()
    private(set) var socket: WebSocket?
    @Published private(set) var connectStatus: WebSocketConnectStatus = .disconnected
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
        guard let base64AuthCredentials = userId.data(using: .utf8)?.base64EncodedString(),
              let url = URL(string: "\(GGLAPI.host)/ws/chat/global/?\(base64AuthCredentials)") else { return }
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
        connectStatus = .connecting
    }

    func disconnect() {
        socket?.disconnect()
    }
}

// MARK: - WebSocketDelegate
extension GGLWebSocketManager: WebSocketDelegate {
    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocketClient) {
        switch event {
        case .connected(_):
            connectStatus = .connected
        case .text(let string):
            onReceivedText(string)
        case .binary(let data):
            Logger().debug("Received data: \(data.count)")
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            Logger().debug("reconnectSuggested")
            break
        case .disconnected(_, _), .cancelled, .error(_), .peerClosed:
            connectStatus = .disconnected
        default:
            break
        }
    }

    private func onReceivedText(_ text: String) {
        guard let model = GGLTool.jsonStringToModel(jsonString: text, to: GGLWebSocketModel.self) else { return }
        GGLWSMessageHelper.handleWebSocketModel(model)
        messageSubject.send(model)
    }
}

extension GGLWebSocketManager {
    enum WebSocketConnectStatus {
        case disconnected
        case connecting
        case connected

        var navigationTitle: String? {
            switch self {
            case .disconnected:
                return "disconnected"
            case .connecting:
                return "connecting..."
            case .connected:
                return nil
            }
        }
    }
}
