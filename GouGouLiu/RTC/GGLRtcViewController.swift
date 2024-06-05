//
//  GGLRtcViewController.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/21.
//

import Foundation

final class GGLRtcViewController: GGLBaseHostingController<GGLRtcContentView> {
    init(role: GGLRtcViewModel.Role, type: GGLWSRtcModel.RtcType, channelId: String, targetId: String) {
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
}
