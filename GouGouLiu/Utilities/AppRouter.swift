//
//  AppRouter.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/7.
//

import UIKit
import URLNavigator

final class AppRouter: NSObject {

    static let shared = AppRouter()

    private lazy var navigator: Navigator = {
        let navigator = Navigator()
        navigator.delegate = self
        return navigator
    }()

    @discardableResult
    func push(_ url: URLConvertible, context: Any? = nil, from: UINavigationControllerType? = nil, animated: Bool = true) -> UIViewController? {
        return navigator.push(url, context: context, from: from, animated: animated)
    }

    @discardableResult
    func push(_ viewController: UIViewController, from: UINavigationControllerType? = nil, animated: Bool = true) -> UIViewController? {
        return navigator.push(viewController, from: from, animated: animated)
    }

    @discardableResult
    func present(_ url: URLConvertible, context: Any? = nil, wrap: UINavigationController.Type? = nil, from: UIViewControllerType? = nil, animated: Bool = true, completion: (() -> Void)? = nil) -> UIViewController? {
        return navigator.present(url, context: context, wrap: wrap, from: from, animated: animated, completion: completion)
    }

    @discardableResult
    func present(_ viewController: UIViewController, wrap: UINavigationController.Type? = nil, from: UIViewControllerType? = nil, animated: Bool = true, completion: (() -> Void)? = nil) -> UIViewController? {
        return navigator.present(viewController, wrap: wrap, from: from, animated: animated, completion: completion)
    }

//    @discardableResult
//    func present(_ viewController: UIViewController, modalPresentationStyle: UIModalPresentationStyle, wrap: UINavigationController.Type? = nil, from: UIViewControllerType? = nil, animated: Bool = true, completion: (() -> Void)? = nil) -> UIViewController? {
//        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(image: .tab_bar_home_normal, style: .plain, target: nil, action: nil)
//        let viewController = viewController.isKind(of: UINavigationController.self) ? viewController : GGLBaseNavigationController(rootViewController: viewController)
//        viewController.modalPresentationStyle = modalPresentationStyle
//        return navigator.present(viewController, wrap: wrap, from: from, animated: animated, completion: completion)
//    }

}

// MARK: - NavigatorDelegate
extension AppRouter: NavigatorDelegate {

    func shouldPush(viewController: UIViewController, from: UINavigationControllerType) -> Bool {
        return true
    }

    func shouldPresent(viewController: UIViewController, from: UIViewControllerType) -> Bool {
        return true
    }

}
