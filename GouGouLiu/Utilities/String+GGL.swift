//
//  String+GGL.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/7.
//

import Foundation
import Moya

extension String {

    static let app_name = "狗狗溜"
    static let app_English_name = "Walk Walk"

    static let Home: String = "Home"
    static let Order: String = "Order"
    static let Message: String = "Message"
    static let Personal: String = "Personal"
    static let Topic: String = "Topic"
    static let ChatRoom: String = "ChatRoom"
    static let Debug: String = "Debug"

}

extension String {

    func multipartFormData(name: String) -> MultipartFormData {
        let valueData = self.data(using: .utf8) ?? Data()
        return MultipartFormData(provider: .data(valueData), name: name)
    }

}
