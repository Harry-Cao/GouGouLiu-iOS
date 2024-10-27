//
//  UpdatePetPhotoView.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/10/26.
//

import SwiftUI
import SDWebImageSwiftUI

struct UpdatePetPhotoView: View {
    let avatarUrl: String?
    let action: () -> Void

    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                action()
            }, label: {
                Text("Update Pet Photo")
            })
            .padding()
            .foregroundStyle(Color(.label))
            .background {
                RoundedRectangle(cornerRadius: 12, style: .circular)
                    .foregroundStyle(Color(.theme_color))
            }
            Spacer()
        }
        .frame(height: 200)
        .background {
            if let avatarUrl {
                WebImage(url: URL(string: avatarUrl))
                    .resizable()
                    .scaledToFill()
            } else {
                Color(.secondarySystemBackground)
            }
        }
        .clipped()
    }
}
