//
//  GGLEditPetViewModel.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/10/26.
//

import SwiftUI

final class GGLEditPetViewModel: ObservableObject {
    private(set) var pageMode: PageMode
    private let petId: String?
    @Published var avatarUrl: String?
    @Published var name: String
    @Published var petType: GGLPetModel.PetType
    @Published var weight: Double?
    @Published var age: Int?
    @Published var sex: GGLPetModel.PetSex
    @Published private var dogBreeds = [GGLBreedModel]()
    @Published private var catBreeds = [GGLBreedModel]()
    private let networkHelper = GGLPetNetworkHelper()

    init(pet: GGLPetModel? = nil) {
        self.pageMode = pet == nil ? .add : .update
        self.petId = pet?.petId
        self.avatarUrl = pet?.avatarUrl
        self.name = pet?.name ?? ""
        self.petType = pet?.petType ?? .dog
        self.weight = pet?.weight
        self.age = pet?.age
        self.sex = pet?.sex ?? .male
        self.breeds = pet?.breeds ?? []
    }

    var breeds: [GGLBreedModel] {
        get {
            switch petType {
            case .dog:
                return dogBreeds
            case .cat:
                return catBreeds
            }
        }
        set {
            switch petType {
            case .dog:
                dogBreeds = newValue
            case .cat:
                catBreeds = newValue
            }
        }
    }

    var saveDisabled: Bool {
        return avatarUrl == nil || name.isEmpty || weight == nil || age == nil || breeds.isEmpty
    }

    func pickPetPhoto() {
        guard let userId = GGLUser.getUserId() else { return }
        GGLUploadPhotoManager.shared.pickImage { image in
            guard let data = image?.fixOrientation().jpegData(compressionQuality: 1) else { return }
            GGLUploadPhotoManager.shared.uploadPhoto(data: data, type: .petPhoto, contactId: userId) { progress in
                ProgressHUD.showServerProgress(progress: progress)
            } completion: { [weak self] model in
                if let self,
                   model.code == .success {
                    avatarUrl = model.data?.previewUrl ?? ""
                }
                ProgressHUD.showServerMsg(model: model)
            }
        }
    }

    func updatePet() {
        guard let userId = GGLUser.getUserId() else { return }
        let petRequest = GGLPetRequest(petType: petType.rawValue, avatarUrl: avatarUrl, name: name, weight: weight, age: age, sex: sex.rawValue, breedIds: breeds.compactMap({ $0.breedId }))
        switch pageMode {
        case .add:
            networkHelper.addPet(userId: userId, pet: petRequest) { [weak self] model in
                guard let self else { return }
                handleUpdateResponse(model)
            }
        case .update:
            guard let petId else { return }
            networkHelper.updatePet(userId: userId, petId: petId, pet: petRequest) { [weak self] model in
                guard let self else { return }
                handleUpdateResponse(model)
            }
        }
    }

    private func handleUpdateResponse(_ model: GGLMoyaModel<GGLPetModel>) {
        if model.code == .success {
            AppRouter.shared.pop(animated: true)
        }
        ProgressHUD.showServerMsg(model: model)
    }

    func deletePet() {
        guard let userId = GGLUser.getUserId(), let petId else { return }
        networkHelper.deletePet(userId: userId, petId: petId) { model in
            if model.code == .success {
                AppRouter.shared.pop(animated: true)
            }
            ProgressHUD.showServerMsg(model: model)
        }
    }
}

extension GGLEditPetViewModel {
    enum PageMode {
        case add
        case update

        var navigationTitle: String {
            switch self {
            case .add:
                return "Add Pet"
            case .update:
                return "Edit Pet"
            }
        }
    }
}
