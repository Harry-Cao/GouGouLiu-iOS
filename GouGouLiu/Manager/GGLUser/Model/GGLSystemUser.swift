//
//  GGLSystemUser.swift
//  GouGouLiu
//
//  Created by Harry Cao on 3/13/24.
//

import Foundation

enum GGLSystemUser: String, CaseIterable {
    case customerService = "10000"
    case gemini = "10001"

    var name: String {
        switch self {
        case .customerService:
            return "狗狗溜客服"
        case .gemini:
            return "Gemini"
        }
    }

    var avatar: String {
        switch self {
        case .customerService:
            return "http://f3.ttkt.cc:12873/GGLServer/media/global/customer_service.jpeg"
        case .gemini:
            return "http://f3.ttkt.cc:12873/GGLServer/media/global/pyy.jpeg"
        }
    }

    var welcomeWords: String {
        switch self {
        case .customerService:
            return "您在使用过程中遇到任何问题都可以向我反馈"
        case .gemini:
            return "Hi, I'm Gemini! A powerful chat bot for you."
        }
    }
}
