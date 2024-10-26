//
//  InputContainer.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/10/26.
//

import SwiftUI

struct InputContainer<Content: View>: View {
    let title: String
    @ViewBuilder let children: () -> Content

    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.subheadline)
                Spacer()
            }
            children()
        }
    }
}
