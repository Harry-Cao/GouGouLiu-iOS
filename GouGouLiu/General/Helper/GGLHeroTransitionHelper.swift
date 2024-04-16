//
//  GGLHeroTransitionHelper.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/15.
//

import Foundation
import Hero

protocol GGLHeroTransitionHelperDelegate: AnyObject {
    func transitionHelperPresentViewController() -> UIViewController?
}

extension GGLHeroTransitionHelperDelegate {
    func transitionHelperPresentViewController() -> UIViewController? {
        return nil
    }
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

    private func addTransitionGesture() {
        guard let viewController = delegate as? UIViewController else { return }
        viewController.view.addGestureRecognizer(leftGesture)
        if let _ = delegate?.transitionHelperPresentViewController() {
            viewController.view.addGestureRecognizer(rightGesture)
        }
    }

    @objc private func handleLeftEdgePanGesture(_ recognizer: UIPanGestureRecognizer) {
        guard let viewController = delegate as? UIViewController,
              let view = viewController.view else { return }
        switch recognizer.state {
        case .began:
            viewController.hero.dismissViewController()
        case .changed:
            let translation = recognizer.translation(in: view)
            let progress = translation.x / view.bounds.width
            Hero.shared.update(progress)
        case .ended, .cancelled:
            if Hero.shared.progress > 0.3 || recognizer.velocity(in: view).x > 100 {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
            }
        default:
            break
        }
    }

    @objc private func handleRightEdgePanGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        guard let viewController = delegate as? UIViewController,
              let view = viewController.view else { return }
        switch recognizer.state {
        case .began:
            guard let toViewController = delegate?.transitionHelperPresentViewController() else { return }
            viewController.present(toViewController, animated: true)
        case .changed:
            let translation = recognizer.translation(in: view)
            let progress = -translation.x / view.bounds.width
            Hero.shared.update(progress)
        case .ended, .cancelled:
            if Hero.shared.progress > 0.3 || recognizer.velocity(in: view).x < -100 {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
            }
        default:
            break
        }
    }
}
