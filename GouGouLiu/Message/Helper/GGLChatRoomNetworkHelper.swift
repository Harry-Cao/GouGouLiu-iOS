//
//  GGLChatRoomNetworkHelper.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/20.
//

import Moya
import RxSwift

struct GGLChatRoomNetworkHelper {
    func requestChannelId(senderId: String, targetId: String) -> Observable<GGLMoyaModel<GGLGetChannelIdModel>> {
        let api = GGLChatRoomAPI(senderId: senderId, targetId: targetId)
        return MoyaProvider<GGLChatRoomAPI>().observable.request(api)
    }
}
