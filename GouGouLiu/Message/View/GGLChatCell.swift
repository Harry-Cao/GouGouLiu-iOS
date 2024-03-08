//
//  GGLChatCell.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2/26/24.
//

import SwiftUI
import SDWebImageSwiftUI

enum GGLChatCellComponentType {
    case avatar
    case content
    case spacer
}

struct GGLChatCell: View {
    let model: GGLChatModel

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            ForEach(components, id: \.self) { type in
                switch type {
                case .avatar:
                    WebImage(url: URL(string: model.avatar ?? ""))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 48, height: 48, alignment: .center)
                        .clipShape(.circle)
                case .content:
                    Text(model.content)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 8, style: .circular)
                                .foregroundColor(Color.gray.opacity(0.2))
                        }
                case .spacer:
                    Spacer()
                }
            }
        }
        .padding()
    }

    private var components: [GGLChatCellComponentType] {
        let components: [GGLChatCellComponentType] = [.avatar, .content, .spacer]
        return model.role == .other ? components : components.reversed()
    }
}
