//
//  MessageCell.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/18.
//

import SwiftUI

struct MessageCell: View {
    let messageModel: MessageModel
    var body: some View {
        HStack(alignment: .top, content: {
            Image(uiImage: .add)
            VStack(alignment: .leading, content: {
                Text(messageModel.name)
                Text(messageModel.message)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            })
        })
    }
}
