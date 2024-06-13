//
//  GGLPublishNetworkHelper.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/5/13.
//

import Foundation
import Combine
import Moya

final class GGLPublishNetworkHelper {
    private let moyaProvider = MoyaProvider<GGLPublishAPI>()
    private var cancellables = Set<AnyCancellable>()

    func requestPublishPost(userId: String, coverUrl: String, photoIDs: [UInt], title: String, content: String?, completion: @escaping (GGLMoyaModel<GGLPostModel>) -> Void) {
        moyaProvider.requestPublisher(.publishPost(userId: userId, coverUrl: coverUrl, photoIDs: photoIDs, title: title, content: content))
            .map(GGLMoyaModel<GGLPostModel>.self)
            .receive(on: DispatchQueue.main)
            .sinkWithDefaultErrorHandle(receiveValue: { completion($0) })
            .store(in: &cancellables)
    }
}
