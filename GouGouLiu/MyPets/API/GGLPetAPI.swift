//
//  GGLPetAPI.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/10/20.
//

import Foundation
import Moya

enum GGLPetAPI: TargetType {
    case addPet(userId: String, pet: [String: Any])
    case updatePet(userId: String, petId: String, pet: [String: Any])
    case deletePet(userId: String, petId: String)
    case getPetOfUser(userId: String)
    case getPet(petId: String)
    case getBreeds(petType: String)

    var baseURL: URL {
        GGLAPI.baseURL
    }

    var path: String {
        switch self {
        case .addPet:
            return "/api/pet/add"
        case .updatePet:
            return "/api/pet/update"
        case .deletePet:
            return "/api/pet/delete"
        case .getPetOfUser:
            return "/api/pet/getPetOfUser"
        case .getPet(let petId):
            return "/api/pet/\(petId)"
        case .getBreeds(let petType):
            return "/api/pet/\(petType)/breeds"
        }
    }

    var method: Moya.Method {
        switch self {
        case .addPet,
                .updatePet,
                .deletePet:
            return .post
        case .getPetOfUser,
                .getPet,
                .getBreeds:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .addPet(let userId, let pet):
            let para: [String: Any] = ["userId": userId, "pet": pet]
            return .requestParameters(parameters: para, encoding: JSONEncoding.default)
        case .updatePet(let userId, let petId, let pet):
            let para: [String: Any] = ["userId": userId, "petId": petId, "pet": pet]
            return .requestParameters(parameters: para, encoding: JSONEncoding.default)
        case .deletePet(let userId, let petId):
            let para: [String: Any] = ["userId": userId, "petId": petId]
            return .requestParameters(parameters: para, encoding: JSONEncoding.default)
        case .getPetOfUser(let userId):
            return .requestParameters(parameters: ["userId": userId], encoding: URLEncoding.default)
        case .getPet,
                .getBreeds:
            return .requestPlain
        }
    }

    var headers: [String : String]? {
        nil
    }
}
