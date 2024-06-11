//
//  Publisher+Moya.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/5/13.
//

import Foundation
import Combine
import Moya

extension Publisher {
    func sinkWithDefaultErrorHandle(receiveCompletion: ((Subscribers.Completion<Self.Failure>) -> Void)? = nil, receiveValue: @escaping ((Output) -> Void)) -> AnyCancellable {
        return sink(receiveCompletion: { completion in
            receiveCompletion?(completion)
            guard case let .failure(error) = completion else { return }
            ProgressHUD.showFailed(error.localizedDescription)
        }, receiveValue: receiveValue)
    }
}

extension Publisher where Output == ProgressResponse {
    func mapProgressResponse<T: Decodable>(_ type: T.Type) -> AnyPublisher<PublisherResponseType<T>, Error> {
        return tryMap { output in
            if let response = output.response {
                let decodeResponse = try response.map(type)
                return .onResponse(decodeResponse)
            } else {
                return .onProgress(output.progress)
            }
        }
        .eraseToAnyPublisher()
    }
}

enum PublisherResponseType<T: Decodable> {
    case onProgress(_ progress: Double)
    case onResponse(_ response: T)
}
