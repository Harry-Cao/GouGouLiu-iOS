//
//  GGLTopicGestureHelper.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/19.
//

import Foundation

protocol GGLTopicGestureHelperDelegate: AnyObject {
    func transitionHelperPushViewController() -> UIViewController?
}

final class GGLTopicGestureHelper {
    weak var delegate: GGLTopicGestureHelperDelegate? {
        didSet {
            addTransitionGesture()
        }
    }
    private(set) lazy var rightGesture: UIScreenEdgePanGestureRecognizer = {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleRightEdgePanGesture))
        gesture.edges = .right
        return gesture
    }()

    private func addTransitionGesture() {
        guard let viewController = delegate as? UIViewController else { return }
        if let _ = delegate?.transitionHelperPushViewController() {
            viewController.view.addGestureRecognizer(rightGesture)
        }
    }

    @objc private func handleRightEdgePanGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        guard let toViewController = delegate?.transitionHelperPushViewController() else { return }
        if recognizer.state == .began {
            AppRouter.shared.push(toViewController)
        }
    }
}
