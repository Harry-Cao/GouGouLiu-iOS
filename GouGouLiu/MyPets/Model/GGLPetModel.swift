//
//  GGLPetModel.swift
//  GouGouLiu
//
//  Created by harry.weixian.cao on 2024/8/27.
//

import Foundation

struct GGLPetModel: Codable {
    let petId: String?
    let petType: PetType?
    let avatarUrl: String?
    let name: String?
    let weight: Double?
    let age: Int?
    let sex: PetSex?
    let breeds: [GGLBreedModel]?
}

extension GGLPetModel {
    enum PetType: Int, Codable {
        case dog
        case cat

        var title: String {
            switch self {
            case .dog:
                return "Dog"
            case .cat:
                return "Cat"
            }
        }
    }
    enum PetSex: Int, Codable {
        case male
        case female

        var title: String {
            switch self {
            case .male:
                return "Male"
            case .female:
                return "Female"
            }
        }
    }
}
