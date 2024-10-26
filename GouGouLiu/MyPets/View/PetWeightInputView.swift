//
//  PetWeightInputView.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/10/26.
//

import SwiftUI

struct PetWeightInputView: View {
    @Binding var weight: Double?

    var body: some View {
        InputContainer(title: "Weight(kg)") {
            TextField("", text: Binding(
                get: {
                    if let weight {
                        return String(weight)
                    } else {
                        return ""
                    }
                },
                set: {
                    weight = Double($0)
                }
            ))
            .padding()
            .keyboardType(.decimalPad)
            .cornerRadius(5.0)
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .circular)
                    .stroke()
                    .foregroundStyle(Color(.lightGray))
            }
        }
    }
}
