//
//  GGLServiceCell.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/5/16.
//

import SwiftUI

struct GGLServiceCell: View {
    let item: ServiceContentView.ServiceType

    var body: some View {
        Button {
            item.action()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: item.iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                    .foregroundColor(Color(uiColor: .theme_color))
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(Font.system(size: 18, weight: .medium))
                    Text(item.description)
                        .font(Font.system(size: 14, weight: .thin))
                }
                .foregroundColor(Color(uiColor: .label))
                Spacer()
            }
            .padding(20)
            .background {
                RoundedRectangle(cornerRadius: 12, style: .circular)
                    .shadow(color: .black.opacity(0.1), radius: 10)
            }
        }
        .foregroundColor(Color(uiColor: .systemBackground))
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 12, trailing: 20))
    }
}
