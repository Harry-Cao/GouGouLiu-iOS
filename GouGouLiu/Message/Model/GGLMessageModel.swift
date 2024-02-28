//
//  GGLMessageModel.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/18.
//

import Foundation

enum GGLMessageType {
    case normal
    case gemini
}

struct GGLMessageModel: Identifiable {
    let id = UUID()
    var type: GGLMessageType = .normal
    let avatar: String?
    let name: String
    let message: String
}
