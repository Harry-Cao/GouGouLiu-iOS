//
//  URLPath.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/7/8.
//

import Foundation

struct GGLAPI {
    static let host = "f3.ttkt.cc:15791"
    static let baseURL = URL(string: "http://\(GGLAPI.host)")!

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

    // WebSocket
    static let chatGlobal = "/ws/chat/global/"
}
