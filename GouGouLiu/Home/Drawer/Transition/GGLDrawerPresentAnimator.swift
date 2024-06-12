//
//  GGLDrawerPresentAnimator.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/6/12.
//

import Foundation

final class GGLDrawerPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private weak var dimmingView: UIView?

    init(dimmingView: UIView) {
        self.dimmingView = dimmingView
    }

    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        0.3
    }

    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else {
            return
        }
        let containerView = transitionContext.containerView
        dimmingView?.alpha = 0
        toView.frame = containerView.bounds.offsetBy(dx: containerView.bounds.width, dy: 0)
        containerView.addSubview(toView)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toView.frame = containerView.bounds.offsetBy(dx: 0, dy: 0)
            self.dimmingView?.alpha = 1
        }, completion: { finished in
            transitionContext.completeTransition(finished)
        })
    }
}
