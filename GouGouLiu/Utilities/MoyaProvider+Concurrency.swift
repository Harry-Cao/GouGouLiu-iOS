//
//  MoyaProvider+Concurrency.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/14.
//

import Moya

extension MoyaProvider {
    struct MoyaConcurrency {
        private let provider: MoyaProvider

        init(provider: MoyaProvider) {
            self.provider = provider
        }

        func request<T: Decodable>(_ target: Target,
                                   callbackQueue: DispatchQueue? = .global(qos: .utility),
                                   progressBlock: ProgressBlock? = nil) async throws -> T {
            return try await withCheckedThrowingContinuation { continuation in
                provider.request(target, callbackQueue: callbackQueue, progress: progressBlock) { result in
                    switch result {
                    case .success(let response):
                        do {
                            let decoder = JSONDecoder()
                            decoder.dateDecodingStrategy = .iso8601
                            let res = try response.map(T.self,
                                                       atKeyPath: "",
                                                       using: decoder,
                                                       failsOnEmptyData: false)
                            continuation.resume(returning: res)
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }

    var async: MoyaConcurrency {
        MoyaConcurrency(provider: self)
    }
}
