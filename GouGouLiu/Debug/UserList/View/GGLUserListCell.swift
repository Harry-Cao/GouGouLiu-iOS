//
//  GGLUserListCell.swift
//  GouGouLiu
//
//  Created by Harry Cao on 3/15/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct GGLUserListCell: View {
    var userModel: GGLUserModel

    var body: some View {
        HStack(alignment: .center, spacing: 12, content: {
            WebImage(url: URL(string: userModel.avatarUrl ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 48, height: 48, alignment: .center)
                .clipShape(.circle)
            VStack(alignment: .leading, spacing: 4, content: {
                Text(userModel.userName ?? "")
                    .font(.headline)
                    .lineLimit(1)
                Text("个性签名：")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .offset(x: 2, y: 0)
                    .lineLimit(2)
            })
            Spacer()
        })
    }
}
