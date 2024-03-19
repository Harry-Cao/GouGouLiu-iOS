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
            ZStack {
                WebImage(url: URL(string: GGLUser.getUser(userId: messageModel.userId)?.avatarUrl ?? ""))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 48, height: 48, alignment: .center)
                    .clipShape(.circle)
                if messageModel.unReadNum > 0 {
                    ZStack {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 20, height: 20)
                        Text(String(messageModel.unReadNum))
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    .offset(x: 20, y: -20)
                }
            }
            VStack(alignment: .leading, spacing: 4, content: {
                Text(GGLUser.getUser(userId: messageModel.userId)?.userName ?? "")
                    .font(.headline)
                    .lineLimit(1)
                Text(messageModel.displayText)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .offset(x: 2, y: 0)
                    .lineLimit(2)
            })
            Spacer()
        })
    }
}
