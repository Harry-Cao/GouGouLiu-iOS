//
//  GGLChatMessageAdapter.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2/26/24.
//

import SwiftUI

struct GGLChatMessageAdapter: View {
    let model: GGLChatBaseModel
    var body: some View {
        switch model.type {
        case .text:
            if let messageModel = model as? GGLChatTextModel {
                GGLChatCell(model: messageModel)
            } else {
                EmptyView()
            }
        }
    }
}
