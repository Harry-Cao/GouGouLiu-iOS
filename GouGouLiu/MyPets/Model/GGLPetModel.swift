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
    var breed: String?
    var avatarUrl: String?
    var name: String?
    var month: Int?
    var weight: Double?

    init(_ type: PetType, breed: String? = nil, avatarUrl: String? = nil, name: String? = nil, month: Int? = nil, weight: Double? = nil) {
        self.id = UUID().hashValue
        self.type = type
        self.breed = breed
        self.avatarUrl = avatarUrl
        self.name = name
        self.month = month
        self.weight = weight
    }
}

extension GGLPetModel {
    enum PetType: Codable {
        case dog
        case cat
    }
}
