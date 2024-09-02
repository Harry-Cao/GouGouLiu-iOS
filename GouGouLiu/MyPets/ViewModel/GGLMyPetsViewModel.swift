//
//  GGLMyPetsViewModel.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/9/1.
//

import SwiftUI

final class GGLMyPetsViewModel: ObservableObject {
    @Published private(set) var myPets = [GGLPetModel]()

    func requestData() {
        let dog = GGLPetModel(.dog,
                              breed: "Samoyed",
                              avatarUrl: "http://f3.ttkt.cc:12873/GGLServer/media/global/customer_service.jpeg",
                              name: "Cotton",
                              month: 12,
                              weight: 22.5)
        myPets = [dog]
    }
}
