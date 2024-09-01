//
//  GGLOrderModel.swift
//  GouGouLiu
//
//  Created by harry.weixian.cao on 2024/8/27.
//

import Foundation

final class GGLOrderModel: Codable {
    var type: OrderType?
    var isRealTime: Bool = false
    var pets: [GGLPetModel]?
    var requirements: String?

    init(type: OrderType? = nil, isRealTime: Bool, pets: [GGLPetModel]? = nil, requirements: String? = nil) {
        self.type = type
        self.isRealTime = isRealTime
        self.pets = pets
        self.requirements = requirements
    }
}

extension GGLOrderModel {
    enum OrderType: Codable {
        case walkingDog
    }
}
