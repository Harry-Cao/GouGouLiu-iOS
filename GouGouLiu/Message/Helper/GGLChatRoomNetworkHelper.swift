//
//  GGLChatRoomNetworkHelper.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/20.
//

import Moya
import Combine

class GGLChatRoomNetworkHelper {
    private let provider = MoyaProvider<GGLChatRoomAPI>()
    private var cancellables = Set<AnyCancellable>()

    func requestChannelId(senderId: String, targetId: String, completion: @escaping (GGLMoyaModel<GGLGetChannelIdModel>) -> Void) {
        provider.requestPublisher(GGLChatRoomAPI(senderId: senderId, targetId: targetId))
            .map(GGLMoyaModel<GGLGetChannelIdModel>.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { completion($0) })
            .store(in: &cancellables)
    }
}
