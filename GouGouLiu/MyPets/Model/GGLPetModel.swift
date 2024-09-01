//
//  GGLPetModel.swift
//  GouGouLiu
//
//  Created by harry.weixian.cao on 2024/8/27.
//

import Foundation

final class GGLPetModel: Codable {
    let id: Int
    let type: PetType?
    var avatarUrl: String?
    var name: String?
    var age: Int?
    var weight: Double?

    init(_ type: PetType, avatarUrl: String? = nil, name: String? = nil, age: Int? = nil, weight: Double? = nil) {
        self.id = UUID().hashValue
        self.type = type
        self.avatarUrl = avatarUrl
        self.name = name
        self.age = age
        self.weight = weight
    }
}

extension GGLPetModel {
    enum PetType: Codable {
        case dog
        case cat
    }
}
