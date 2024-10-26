//
//  GGLPetRequest.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/10/21.
//

import Foundation

struct GGLPetRequest: Codable {
    let petType: Int?
    let avatarUrl: String?
    let name: String?
    let weight: Double?
    let age: Int?
    let sex: Int?
    let breedIds: [Int]?
}
