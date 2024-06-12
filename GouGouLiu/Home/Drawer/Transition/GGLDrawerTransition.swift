//
//  GGLDrawerTransition.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/6/12.
//

import Foundation

final class GGLDrawerTransition: NSObject {
    private weak var presentedViewController: UIViewController?
    private lazy var dimmingView: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black.withAlphaComponent(0.5)
        button.alpha = 0
        button.addTarget(self, action: #selector(dismissPresentedViewController), for: .touchUpInside)
        return button
    }()

    @objc private func dismissPresentedViewController() {
        presentedViewController?.dismiss(animated: true)
    }
}

extension GGLDrawerTransition: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        presentedViewController = presented
        return GGLDrawerPresentationController(presentedViewController: presented, presenting: presenting, dimmingView: dimmingView)
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        GGLDrawerPresentAnimator(dimmingView: dimmingView)
    }

    func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        GGLDrawerDismissAnimator(dimmingView: dimmingView)
    }
}
