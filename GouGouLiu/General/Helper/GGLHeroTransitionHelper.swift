//
//  GGLHeroTransitionHelper.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/15.
//

import Foundation
import Hero

protocol GGLHeroTransitionHelperDelegate: AnyObject {
    // Required
    func transitionHelperGestureViewController() -> UIViewController?
    func transitionHelperNeedRightEdgeGesture() -> Bool
    // Optional
    func transitionHelperPresentViewController() -> UIViewController?
    func transitionHelperDismissAnimationType() -> HeroDefaultAnimationType
    func transitionHelperPresentAnimationType() -> HeroDefaultAnimationType
}

extension GGLHeroTransitionHelperDelegate {
    func transitionHelperPresentViewController() -> UIViewController? { nil }
    func transitionHelperDismissAnimationType() -> HeroDefaultAnimationType { .auto }
    func transitionHelperPresentAnimationType() -> HeroDefaultAnimationType { .auto }
}

final class GGLHeroTransitionHelper: NSObject {
    weak var delegate: GGLHeroTransitionHelperDelegate? {
        didSet {
            addTransitionGesture()
        }
    }
    private(set) lazy var leftGesture: UIScreenEdgePanGestureRecognizer = {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleLeftEdgePanGesture))
        gesture.edges = .left
        return gesture
    }()
    private(set) lazy var rightGesture: UIScreenEdgePanGestureRecognizer = {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleRightEdgePanGesture))
        gesture.edges = .right
        return gesture
    }()
    private var gestureViewController: UIViewController?
    private var toViewController: UIViewController?

    private func addTransitionGesture() {
        guard let viewController = delegate?.transitionHelperGestureViewController() else { return }
        if viewController.isPresented {
            viewController.view.addGestureRecognizer(leftGesture)
        }
        if delegate?.transitionHelperNeedRightEdgeGesture() == true {
            viewController.view.addGestureRecognizer(rightGesture)
        }
    }

    @objc private func handleLeftEdgePanGesture(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            guard let gestureViewController = delegate?.transitionHelperGestureViewController(),
                  let dismissAnimationType = delegate?.transitionHelperDismissAnimationType() else { return }
            self.gestureViewController = gestureViewController
            gestureViewController.setHeroModalAnimationType(dismissAnimationType)
            gestureViewController.hero.dismissViewController()
        case .changed:
            guard let view = gestureViewController?.view else { return }
            let translation = recognizer.translation(in: view)
            let progress = translation.x / view.bounds.width
            Hero.shared.update(progress)
        case .ended, .cancelled:
            guard let view = gestureViewController?.view else { return }
            if Hero.shared.progress > 0.3 || recognizer.velocity(in: view).x > 100 {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
            }
            fallthrough
        default:
            self.gestureViewController?.isHeroEnabled = false
            self.gestureViewController = nil
        }
    }

    @objc private func handleRightEdgePanGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            guard let toViewController = delegate?.transitionHelperPresentViewController(),
                  let gestureViewController = delegate?.transitionHelperGestureViewController(),
                  let presentAnimationType = delegate?.transitionHelperDismissAnimationType() else { return }
            self.toViewController = toViewController
            self.gestureViewController = gestureViewController
            toViewController.setHeroModalAnimationType(presentAnimationType)
            gestureViewController.present(toViewController, animated: true)
        case .changed:
            guard let view = gestureViewController?.view else { return }
            let translation = recognizer.translation(in: view)
            let progress = -translation.x / view.bounds.width
            Hero.shared.update(progress)
        case .ended, .cancelled:
            guard let view = gestureViewController?.view else { return }
            if Hero.shared.progress > 0.3 || recognizer.velocity(in: view).x < -100 {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
            }
            fallthrough
        default:
            self.toViewController?.isHeroEnabled = false
            self.toViewController = nil
            self.gestureViewController = nil
        }
    }

    func dismiss() {
        guard let gestureViewController = delegate?.transitionHelperGestureViewController(),
              let dismissAnimationType = delegate?.transitionHelperDismissAnimationType() else { return }
        gestureViewController.setHeroModalAnimationType(dismissAnimationType)
        gestureViewController.hero.dismissViewController()
    }
}
