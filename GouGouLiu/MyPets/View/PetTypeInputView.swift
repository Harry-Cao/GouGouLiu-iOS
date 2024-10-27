//
//  PetTypeInputView.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/10/26.
//

import SwiftUI

struct PetTypeInputView: View {
    @Binding var petType: GGLPetModel.PetType

    var body: some View {
        InputContainer(title: "What type of pet?") {
            HStack(spacing: 12, content: {
                PetButton(petType: .dog, selected: petType == .dog) {
                    petType = .dog
                }
                PetButton(petType: .cat, selected: petType == .cat) {
                    petType = .cat
                }
            })
        }
    }

    struct PetButton: View {
        let petType: GGLPetModel.PetType
        let selected: Bool
        let action: () -> Void

        var body: some View {
            Button(action: {
                action()
            }, label: {
                HStack {
                    Spacer()
                    VStack(spacing: 12, content: {
                        Image(systemName: petType.title.lowercased())
                        Text(petType.title)
                            .font(.callout)
                    })
                    Spacer()
                }
                .padding()
                .overlay {
                    RoundedRectangle(cornerSize: CGSize(width: 4, height: 4), style: .circular)
                        .stroke()
                }
                .foregroundStyle(Color(selected ? .label : .lightGray))
            })
        }
    }
}
