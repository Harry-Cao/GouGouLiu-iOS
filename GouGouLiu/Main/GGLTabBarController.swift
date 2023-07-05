//
//  GGLTabBarController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/5.
//

import UIKit

final class GGLTabBarController: UITabBarController {

    private let homeViewController = GGLHomeViewController()
    private let messageViewController = GGLMessageViewController()
    private let personalViewController = GGLPersonalViewController()

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
                                                                 image: .tab_bar_home_normal,
                                                                 selectedImage: .tab_bar_home_selected)
        let messageNavigationController = setupNavigationController(viewController: messageViewController,
                                                                    title: .Message,
                                                                    image: .tab_bar_message_normal,
                                                                    selectedImage: .tab_bar_message_selected)
        let personalNavigationController = setupNavigationController(viewController: personalViewController,
                                                                     title: .Personal,
                                                                     image: .tab_bar_personal_normal,
                                                                     selectedImage: .tab_bar_personal_selected)
        let viewControllers: [UIViewController] = [
            homeNavigationController,
            messageNavigationController,
            personalNavigationController
        ]
        self.viewControllers = viewControllers
    }

    private func setupNavigationController(viewController: UIViewController,
                                           title: String?,
                                           image: UIImage?,
                                           selectedImage: UIImage?) -> GGLBaseNavigationController {
        let navigationController = GGLBaseNavigationController(rootViewController: viewController)
        let tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        navigationController.tabBarItem = tabBarItem
        return navigationController
    }

}
