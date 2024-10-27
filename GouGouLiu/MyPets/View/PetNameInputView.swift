//
//  PetNameInputView.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/10/26.
//

import SwiftUI

struct PetNameInputView: View {
    @Binding var name: String

    var body: some View {
        InputContainer(title: "Name") {
            TextField("", text: $name)
                .padding()
                .disableAutocorrection(true)
                .cornerRadius(5.0)
                .overlay {
                    RoundedRectangle(cornerRadius: 8, style: .circular)
                        .stroke()
                        .foregroundStyle(Color(.lightGray))
                }
        }
    }
}
