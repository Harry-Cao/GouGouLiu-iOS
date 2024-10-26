//
//  PetAgeInputView.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/10/26.
//

import SwiftUI

struct PetAgeInputView: View {
    @Binding var age: Int?

    var body: some View {
        InputContainer(title: "Age(month)") {
            TextField("", text: Binding(
                get: {
                    if let age {
                        return String(age)
                    } else {
                        return ""
                    }
                },
                set: {
                    age = Int($0)
                }
            ))
            .padding()
            .keyboardType(.numberPad)
            .cornerRadius(5.0)
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .circular)
                    .stroke()
                    .foregroundStyle(Color(.lightGray))
            }
        }
    }
}
