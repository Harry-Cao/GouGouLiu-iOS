//
//  GGLRtcViewController.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/21.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

final class GGLRtcViewController: GGLBaseHostingController<GGLRtcContentView> {

    init(role: GGLRtcViewModel.Role, channelId: String, targetId: String) {
        let viewModel = GGLRtcViewModel(role: role, channelId: channelId, targetId: targetId)
        super.init(rootView: GGLRtcContentView(viewModel: viewModel))
        self.modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

struct GGLRtcContentView: View {
    @ObservedObject var viewModel: GGLRtcViewModel

    var body: some View {
        ZStack {
            WebImage(url: URL(string: viewModel.targetUser?.avatarUrl ?? ""))
                .blur(radius: 20)
            VStack {
                WebImage(url: URL(string: viewModel.targetUser?.avatarUrl ?? ""))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100, alignment: .center)
                    .clipShape(.circle)
            }
        }
        .onAppear(perform: {
            viewModel.onAppear()
        })
    }
}
