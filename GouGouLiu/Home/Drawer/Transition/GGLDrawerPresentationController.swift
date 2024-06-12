//
//  GGLDrawerPresentationController.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/6/12.
//

import Foundation

final class GGLDrawerPresentationController: UIPresentationController {
    private(set) lazy var dimmingView: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black.withAlphaComponent(0.5)
        button.alpha = 0
        button.addTarget(self, action: #selector(dismissPresentedViewController), for: .touchUpInside)
        return button
    }()

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let containerView = containerView else { return }
        containerView.insertSubview(dimmingView, at: 0)
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        dimmingView.frame = containerView?.bounds ?? .zero
    }

    @objc private func dismissPresentedViewController() {
        presentedViewController.dismiss(animated: true)
    }
}
