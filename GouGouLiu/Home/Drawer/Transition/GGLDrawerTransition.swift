//
//  GGLDrawerTransition.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/6/12.
//

import Foundation

final class GGLDrawerTransition: NSObject {
    private var presentationController: GGLDrawerPresentationController?
}

extension GGLDrawerTransition: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        presentationController = GGLDrawerPresentationController(presentedViewController: presented, presenting: presenting)
        return presentationController
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        GGLDrawerPresentAnimator(dimmingView: presentationController?.dimmingView)
    }

    func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        GGLDrawerDismissAnimator(dimmingView: presentationController?.dimmingView)
    }
}
