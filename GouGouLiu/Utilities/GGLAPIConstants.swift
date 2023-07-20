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

    static let api_host = "f3.ttkt.cc:12873"
//    static let api_host = "192.168.0.123:8888"

    static let path_homePagePost = "/api/home/post"
    static let path_uploadPhoto = "/api/photo/upload"
    static let path_clearAllPhoto = "/api/photo/clearAll"

}
