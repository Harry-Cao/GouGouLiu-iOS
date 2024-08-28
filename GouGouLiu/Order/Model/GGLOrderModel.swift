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
    var dogs: [GGLDogModel]?
    var requirements: String?

    init(type: OrderType? = nil, isRealTime: Bool, dogs: [GGLDogModel]? = nil, requirements: String? = nil) {
        self.type = type
        self.isRealTime = isRealTime
        self.dogs = dogs
        self.requirements = requirements
    }
}

extension GGLOrderModel {
    enum OrderType: Codable {
        case walkingDog
    }
}
