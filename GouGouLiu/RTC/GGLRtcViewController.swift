//
//  GGLRtcViewController.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/21.
//

import Foundation
import Combine

final class GGLRtcViewController: GGLBaseHostingController<GGLRtcContentView> {
    private var cancellables = Set<AnyCancellable>()

    init(role: GGLRtcViewModel.Role, type: GGLWSRtcMessageModel.RtcType, channelId: String, targetId: String) {
        super.init(rootView: GGLRtcContentView(viewModel: GGLRtcViewModel.shared))
        self.modalPresentationStyle = .fullScreen
        GGLRtcViewModel.shared.setup(role: role, type: type, channelId: channelId, targetId: targetId, delegate: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - GGLRtcViewModelDelegate
extension GGLRtcViewController: GGLRtcViewModelDelegate {
    func needDismiss() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.dismiss(animated: true)
        }
    }

    func getCancellables() -> Set<AnyCancellable> { cancellables }
}
