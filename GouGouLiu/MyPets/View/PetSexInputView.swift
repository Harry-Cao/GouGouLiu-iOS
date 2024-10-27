//
//  PetSexInputView.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/10/26.
//

import SwiftUI

struct PetSexInputView: View {
    @Binding var sex: GGLPetModel.PetSex

    var body: some View {
        InputContainer(title: "What type of pet?") {
            HStack(spacing: 12, content: {
                SexButton(sex: .male, selected: sex == .male) {
                    sex = .male
                }
                SexButton(sex: .female, selected: sex == .female) {
                    sex = .female
                }
            })
        }
    }

    struct SexButton: View {
        let sex: GGLPetModel.PetSex
        let selected: Bool
        let action: () -> Void

        var body: some View {
            Button(action: {
                action()
            }, label: {
                HStack {
                    Spacer()
                    VStack(spacing: 12, content: {
                        Text(sex.title)
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
