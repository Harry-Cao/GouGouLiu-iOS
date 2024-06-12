//
//  GGLDrawerDismissAnimator.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/6/12.
//

import Foundation

final class GGLDrawerDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private weak var dimmingView: UIView?

    init(dimmingView: UIView) {
        self.dimmingView = dimmingView
    }

    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        0.3
    }
    
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else {
            return
        }
        let containerView = transitionContext.containerView

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromView.frame = containerView.bounds.offsetBy(dx: containerView.bounds.width, dy: 0)
            self.dimmingView?.alpha = 0
        }, completion: { finished in
            fromView.removeFromSuperview()
            transitionContext.completeTransition(finished)
        })
    }
}
