//
//  GGLMessageCell.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/18.
//

import SwiftUI
import SDWebImageSwiftUI

struct GGLMessageCell: View {
    let messageModel: GGLMessageModel
    var body: some View {
        HStack(alignment: .center, spacing: 12, content: {
            WebImage(url: URL(string: messageModel.avatar ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 48, height: 48, alignment: .center)
                .clipShape(.circle)
            VStack(alignment: .leading, spacing: 4, content: {
                Text(messageModel.name)
                    .font(.headline)
                Text(messageModel.messages.last?.content ?? "")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .offset(x: 2, y: 0)
            })
            Spacer()
        })
    }
}
