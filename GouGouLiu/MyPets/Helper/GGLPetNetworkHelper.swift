//
//  GGLPetNetworkHelper.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/10/21.
//

import Foundation
import Moya
import Combine

final class GGLPetNetworkHelper {
    private let provider = MoyaProvider<GGLPetAPI>()
    private var cancellables = Set<AnyCancellable>()

    func addPet(userId: String, pet: GGLPetRequest, completion: @escaping (GGLMoyaModel<GGLPetModel>) -> Void) {
        let petDic = GGLTool.modelToDictionary(pet) ?? [:]
        provider.requestPublisher(.addPet(userId: userId, pet: petDic))
            .map(GGLMoyaModel<GGLPetModel>.self)
            .receive(on: DispatchQueue.main)
            .sinkWithDefaultErrorHandle(receiveValue: { completion($0) })
            .store(in: &cancellables)
    }

    func updatePet(userId: String, petId: String, pet: GGLPetRequest, completion: @escaping (GGLMoyaModel<GGLPetModel>) -> Void) {
        let petDic = GGLTool.modelToDictionary(pet) ?? [:]
        provider.requestPublisher(.updatePet(userId: userId, petId: petId, pet: petDic))
            .map(GGLMoyaModel<GGLPetModel>.self)
            .receive(on: DispatchQueue.main)
            .sinkWithDefaultErrorHandle(receiveValue: { completion($0) })
            .store(in: &cancellables)
    }

    func deletePet(userId: String, petId: String, completion: @escaping (GGLMoyaModel<[String: String]>) -> Void) {
        provider.requestPublisher(.deletePet(userId: userId, petId: petId))
            .map(GGLMoyaModel<[String: String]>.self)
            .receive(on: DispatchQueue.main)
            .sinkWithDefaultErrorHandle(receiveValue: { completion($0) })
            .store(in: &cancellables)
    }

    func getPetOfUser(userId: String, completion: @escaping (GGLMoyaModel<[GGLPetModel]>) -> Void) {
        provider.requestPublisher(.getPetOfUser(userId: userId))
            .map(GGLMoyaModel<[GGLPetModel]>.self)
            .receive(on: DispatchQueue.main)
            .sinkWithDefaultErrorHandle(receiveValue: { completion($0) })
            .store(in: &cancellables)
    }

    func getPet(petId: String, completion: @escaping (GGLMoyaModel<GGLPetModel>) -> Void) {
        provider.requestPublisher(.getPet(petId: petId))
            .map(GGLMoyaModel<GGLPetModel>.self)
            .receive(on: DispatchQueue.main)
            .sinkWithDefaultErrorHandle(receiveValue: { completion($0) })
            .store(in: &cancellables)
    }

    func getBreeds(petType: GGLPetModel.PetType, completion: @escaping (GGLMoyaModel<[GGLBreedModel]>) -> Void) {
        provider.requestPublisher(.getBreeds(petType: petType.title.lowercased()))
            .map(GGLMoyaModel<[GGLBreedModel]>.self)
            .receive(on: DispatchQueue.main)
            .sinkWithDefaultErrorHandle(receiveValue: { completion($0) })
            .store(in: &cancellables)
    }
}
