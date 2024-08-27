//
//  URLPath.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/7/8.
//

import Foundation

struct GGLAPI {
    static let host: String = UserDefaults.host.rawValue
    static let baseURL: URL = URL(string: host)!
}

extension GGLAPI {
    enum Host: String, CaseIterable {
        case internet = "http://f3.ttkt.cc:15791"
        case intranet = "http://192.168.0.211:8888"
    }
}

extension GGLAPI {
    enum Path {
        static let homePagePost = "/api/home/post"
        static let uploadPhoto = "/api/photo/upload"
        static let clearAllPhoto = "/api/photo/clearAll"
        static let getUser = "/api/user"
        static let userSignup = "/api/user/signup"
        static let userLogin = "/api/user/login"
        static let userLogout = "/api/user/logout"
        static let allUsers = "/api/user/allUsers"
        static let userClearAll = "/api/user/clearAll"
        static let publishPost = "/api/post/publish"
        static let postClearAll = "/api/post/clearAll"
        static let searchPost = "/api/post/search"
        static let getChannelId = "/api/chat/getChannelId"
    }
}

extension GGLAPI {
    enum WS {
        static let chatGlobal = "/ws/chat/global/"
    }
}
