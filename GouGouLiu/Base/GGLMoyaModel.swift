//
//  GGLMoyaModel.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/22/23.
//

import Foundation

struct GGLMoyaModel<T: Codable>: Codable {

    var code: ResultCode?
    var msg: String?
    var data: T?

}

extension GGLMoyaModel {

    enum ResultCode: Int, Codable {
        case success
        case failed
    }

}
