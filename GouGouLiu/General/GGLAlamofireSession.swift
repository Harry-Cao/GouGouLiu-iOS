//
//  GGLAlamofireSession.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/24.
//

import Alamofire

final class GGLAlamofireSession: Alamofire.Session {
    static let shared: GGLAlamofireSession = {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        configuration.timeoutIntervalForRequest = 5
        configuration.timeoutIntervalForResource = 30
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return GGLAlamofireSession(configuration: configuration)
    }()
}
