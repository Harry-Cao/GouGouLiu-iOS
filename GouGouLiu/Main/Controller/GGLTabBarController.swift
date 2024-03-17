//
//  GGLTabBarController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/5.
//

import UIKit
import RxSwift

final class GGLTabBarController: UITabBarController {

    private let homeViewController = GGLHomeViewController()
    private let orderViewController = GGLOrderViewController()
    private let emptyViewController = UIViewController()
    private let messageViewController = GGLMessageViewController()
    private let personalViewController = GGLPersonalViewController()
    private(set) var disposeBag = DisposeBag()
    private(set) lazy var unReadNumView = GGLTabBarUnReadNumView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewControllers()
        setupMiddleButton()
        subscribe()
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
            emptyViewController,
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

    private func setupMiddleButton() {
        let middleButton = UIButton()
        middleButton.setImage(.tab_bar_extension, for: .normal)
        middleButton.backgroundColor = .systemBackground
        middleButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        middleButton.layer.cornerRadius = 40
        let middleBarButton = tabBar.subviews[2]
        middleBarButton.addSubview(middleButton)
        middleButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-15)
            make.leading.bottom.trailing.equalToSuperview()
        }
        middleButton.addTarget(self, action: #selector(didTapMiddleButton(sender:)), for: .touchUpInside)
    }

    @objc private func didTapMiddleButton(sender: UIButton) {
        let optionViewController = GGLPublishOptionViewController()
        optionViewController.modalPresentationStyle = .fullScreen
        AppRouter.shared.present(optionViewController)
    }

}
