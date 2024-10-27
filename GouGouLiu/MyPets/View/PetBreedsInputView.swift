//
//  PetBreedsInputView.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/10/26.
//

import SwiftUI

struct PetBreedsInputView: View {
    @Binding var breeds: [GGLBreedModel]
    let action: () -> Void

    var body: some View {
        InputContainer(title: "Breed(s)") {
            Button(action: {
                action()
            }, label: {
                HStack(spacing: 0) {
                    Text(breeds.compactMap({ $0.breedName }).joined(separator: ", "))
                    Spacer()
                }
                .padding()
                .foregroundStyle(Color(.label))
                .cornerRadius(5.0)
                .overlay {
                    RoundedRectangle(cornerRadius: 8, style: .circular)
                        .stroke()
                        .foregroundStyle(Color(.lightGray))
                }
            })
        }
    }
}
