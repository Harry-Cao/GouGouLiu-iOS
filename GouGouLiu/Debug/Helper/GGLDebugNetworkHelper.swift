//
//  GGLDebugNetworkHelper.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/5/13.
//

import Foundation
import Combine
import Moya

class GGLDebugNetworkHelper {
    static let shared = GGLDebugNetworkHelper()
    private let moyaProvider = MoyaProvider<GGLPublishAPI>()
    private var cancellables = Set<AnyCancellable>()

    func clearAllPost(userId: String, completion: @escaping (GGLMoyaModel<GGLPostModel>) -> Void) {
        moyaProvider.requestPublisher(.clearAll(userId: userId))
            .map(GGLMoyaModel<GGLPostModel>.self)
            .receive(on: DispatchQueue.main)
            .sinkWithDefaultErrorHandle(receiveValue: { completion($0) })
            .store(in: &cancellables)
    }
}
