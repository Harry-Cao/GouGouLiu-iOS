//
//  GGLPostNetworkHelper.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/5/13.
//

import Foundation
import Combine
import Moya

class GGLPostNetworkHelper {
    private let moyaProvider = MoyaProvider<GGLPostAPI>()
    private var cancellables = Set<AnyCancellable>()

    func requestPublishPost(userId: String, coverUrl: String, imageUrls: [String], title: String, content: String?, completion: @escaping (GGLMoyaModel<GGLPostModel>) -> Void) {
        moyaProvider.requestPublisher(.publish(userId: userId, coverUrl: coverUrl, imageUrls: imageUrls, title: title, content: content))
            .map(GGLMoyaModel<GGLPostModel>.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { completion($0) })
            .store(in: &cancellables)
    }
}
