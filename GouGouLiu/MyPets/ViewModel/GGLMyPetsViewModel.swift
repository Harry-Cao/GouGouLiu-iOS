//
//  GGLMyPetsViewModel.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/9/1.
//

import SwiftUI

final class GGLMyPetsViewModel: ObservableObject {
    @Published private(set) var myPets = [GGLPetModel]()
    private let networkHelper = GGLPetNetworkHelper()

    func requestMyPets() {
        guard let userId = GGLUser.getUserId() else { return }
        networkHelper.getPetOfUser(userId: userId) { [weak self] response in
            guard let self else { return }
            myPets = response.data ?? []
        }
    }
}
