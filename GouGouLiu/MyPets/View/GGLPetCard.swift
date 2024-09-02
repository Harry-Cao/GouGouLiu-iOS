//
//  GGLPetCard.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/9/2.
//

import SwiftUI
import SDWebImageSwiftUI

struct GGLPetCard: View {
    let pet: GGLPetModel

    var body: some View {
        Button(action: {
            
        }, label: {
            VStack {
                HStack(alignment: .top, spacing: 12, content: {
                    WebImage(url: URL(string: pet.avatarUrl ?? ""))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 48, height: 48, alignment: .center)
                        .clipShape(.circle)
                    HStack {
                        VStack(alignment: .leading, spacing: 4, content: {
                            Text(pet.name ?? "")
                            Text(pet.breed ?? "")
                                .font(.subheadline)
                                .foregroundStyle(Color(.secondaryLabel))
                            Text(detailInfo)
                                .font(.subheadline)
                                .foregroundStyle(Color(.secondaryLabel))
                        })
                        Spacer()
                    }
                })
            }
            .padding()
        })
        .foregroundStyle(Color(.label))
        .background(Color(.secondarySystemBackground))
        .background {
            RoundedRectangle(cornerRadius: 12, style: .circular)
                .shadow(color: .black.opacity(0.2), radius: 10)
        }
        .padding([.leading, .top, .trailing], 20)
    }

    private var petWeight: String {
        return "\(pet.weight ?? 0) kg"
    }

    private var petAge: String {
        return "\(pet.month ?? 0) months old"
    }

    private var detailInfo: String {
        return "\(petWeight), \(petAge)"
    }
}
