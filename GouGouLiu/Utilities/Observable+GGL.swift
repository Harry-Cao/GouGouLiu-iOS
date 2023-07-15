//
//  Observable+GGL.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/7/5.
//

import RxSwift
import Moya
import Foundation

extension Observable where Element: Decodable {
    static func ofRequest<API>(api: API,
                               provider: MoyaProvider<API>,
                               callbackQueue: DispatchQueue? = .global(qos: .utility))
        -> Observable<Element> where API: TargetType {
            return Observable<Element>.create { observer -> Disposable in
                provider.request(api, callbackQueue: callbackQueue) { response in
                    switch response {
                    case .success(let value):
                        do {
                            let decoder = JSONDecoder()
                            decoder.dateDecodingStrategy = .iso8601
                            let questions = try value.map(Element.self,
                                                          atKeyPath: "",
                                                          using: decoder,
                                                          failsOnEmptyData: false)
                            observer.onNext(questions)
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
