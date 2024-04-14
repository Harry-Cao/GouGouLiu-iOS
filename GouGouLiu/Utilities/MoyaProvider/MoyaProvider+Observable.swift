//
//  MoyaProvider+Observable.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/14.
//

import Moya
import RxSwift

extension MoyaProvider {
    struct MoyaObservable {
        private let provider: MoyaProvider

        init(provider: MoyaProvider) {
            self.provider = provider
        }

        func request<T: Decodable>(_ target: Target,
                                   callbackQueue: DispatchQueue? = .global(qos: .utility),
                                   progressBlock: ProgressBlock? = nil)
        -> Observable<T> {
            return Observable.create { observer -> Disposable in
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
                            observer.onNext(res)
                            observer.onCompleted()
                        } catch {
                            observer.onError(error)
                        }
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
                return Disposables.create()
            }
        }
    }

    var observable: MoyaObservable {
        MoyaObservable(provider: self)
    }
}

