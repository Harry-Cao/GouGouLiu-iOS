//
//  GGLTabBarController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/5.
//

import UIKit

final class GGLTabBarController: UITabBarController {

    private let homeViewController = GGLHomeViewController()
    private let orderViewController = GGLOrderViewController()
    private let messageViewController = GGLMessageViewController(rootView: MessageContentView())
    private let personalViewController = GGLPersonalViewController(rootView: PersonalContentView())

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewControllers()
    }

    private func setupUI() {
        self.view.backgroundColor = .systemBackground
    }

    private func setupViewControllers() {
        let homeNavigationController = setupNavigationController(viewController: homeViewController,
                                                                 title: .Home,
                                                                 normalImage: .tab_bar_home_normal,
                                                                 selectedImage: .tab_bar_home_selected)
        let orderNavigationController = setupNavigationController(viewController: orderViewController,
                                                                 title: .Order,
                                                                 normalImage: .tab_bar_order_normal,
                                                                 selectedImage: .tab_bar_order_selected)
        let messageNavigationController = setupNavigationController(viewController: messageViewController,
                                                                    title: .Message,
                                                                    normalImage: .tab_bar_message_normal,
                                                                    selectedImage: .tab_bar_message_selected)
        let personalNavigationController = setupNavigationController(viewController: personalViewController,
                                                                     title: .Personal,
                                                                     normalImage: .tab_bar_personal_normal,
                                                                     selectedImage: .tab_bar_personal_selected)
        let viewControllers: [UIViewController] = [
            homeNavigationController,
            orderNavigationController,
            messageNavigationController,
            personalNavigationController
        ]
        self.viewControllers = viewControllers
    }

    private func setupNavigationController(viewController: UIViewController,
                                           title: String?,
                                           normalImage: UIImage?,
                                           selectedImage: UIImage?) -> GGLBaseNavigationController {
        let navigationController = GGLBaseNavigationController(rootViewController: viewController)
        // make the image could show their original color
        let normalImage = normalImage?.withRenderingMode(.alwaysOriginal)
        let selectedImage = selectedImage?.withRenderingMode(.alwaysOriginal)
        let tabBarItem = UITabBarItem(title: title, image: normalImage, selectedImage: selectedImage)
        navigationController.tabBarItem = tabBarItem
        return navigationController
    }

}
