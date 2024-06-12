//
//  GGLDrawerPresentationController.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/6/12.
//

import Foundation

final class GGLDrawerPresentationController: UIPresentationController {
    private weak var dimmingView: UIView?

    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, dimmingView: UIView) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.dimmingView = dimmingView
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let containerView = containerView,
              let dimmingView = dimmingView else { return }
        containerView.insertSubview(dimmingView, at: 0)
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        dimmingView?.frame = containerView?.bounds ?? .zero
    }
}
