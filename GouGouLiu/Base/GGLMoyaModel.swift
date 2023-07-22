//
//  GGLMoyaModel.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/22/23.
//

import Foundation

final class GGLMoyaModel<T: Codable>: Codable {

    var code: Int?
    var msg: String?
    var data: T?

}
