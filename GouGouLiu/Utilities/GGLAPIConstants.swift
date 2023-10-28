//
//  URLPath.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/7/8.
//

import Foundation

extension URL {

    static let api_baseURL = URL(string: "http://\(String.api_host)")!

}

extension String {

    static let api_host = "f3.ttkt.cc:14648"
//    static let api_host = "192.168.0.211:8888"

    static let path_homePagePost = "/api/home/post"
    static let path_uploadPhoto = "/api/photo/upload"
    static let path_clearAllPhoto = "/api/photo/clearAll"
    static let path_userSignup = "/api/user/signup"
    static let path_userLogin = "/api/user/login"
    static let path_userLogout = "/api/user/logout"
    static let path_userClearAll = "/api/user/clearAll"
    static let path_publishPost = "/api/post/publish"
    static let path_postClearAll = "/api/post/clearAll"
    static let path_searchPost = "api/post/search"

}
