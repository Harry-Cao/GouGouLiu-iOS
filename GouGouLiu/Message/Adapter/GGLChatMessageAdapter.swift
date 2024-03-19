//
//  GGLChatMessageAdapter.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2/26/24.
//

import SwiftUI

struct GGLChatMessageAdapter: View {
    let model: GGLChatModel
    var body: some View {
        switch model.type {
        case .text, .photo:
            GGLChatCell(model: model)
        }
    }
}
