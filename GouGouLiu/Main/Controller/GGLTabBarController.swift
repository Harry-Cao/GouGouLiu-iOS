//
//  GGLTabBarController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/5.
//

import UIKit
import Combine

final class GGLTabBarController: UITabBarController {

    private let homeViewController = GGLHomeViewController()
    private let serviceViewController = GGLServicesViewController()
    private let emptyViewController = UIViewController()
    private let messageViewController = GGLMessageViewController()
    private let personalViewController = GGLPersonalViewController()
    private(set) var cancellables = Set<AnyCancellable>()

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
                                                                 normalImage: UIImage(resource: .tabBarHomeNormal),
                                                                 selectedImage: UIImage(resource: .tabBarHomeSelected))
        let serviceNavigationController = setupNavigationController(viewController: serviceViewController,
                                                                 title: .Services,
                                                                 normalImage: UIImage(resource: .tabBarServicesNormal),
                                                                 selectedImage: UIImage(resource: .tabBarServicesSelected))
        let messageNavigationController = setupNavigationController(viewController: messageViewController,
                                                                    title: .Message,
                                                                    normalImage: UIImage(resource: .tabBarMessageNormal),
                                                                    selectedImage: UIImage(resource: .tabBarMessageSelected))
        let personalNavigationController = setupNavigationController(viewController: personalViewController,
                                                                     title: .Personal,
                                                                     normalImage: UIImage(resource: .tabBarPersonalNormal),
                                                                     selectedImage: UIImage(resource: .tabBarPersonalSelected))
        let viewControllers: [UIViewController] = [
            homeNavigationController,
            serviceNavigationController,
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
        middleButton.setImage(UIImage(resource: .tabBarExtension), for: .normal)
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

    private func subscribe() {
        GGLDataBase.shared.messageUnReadSubject.sink { [weak self] _ in
            guard let self else { return }
            updateMessageUnReadNum()
        }.store(in: &cancellables)
        GGLUser.userStatusSubject.sink { [weak self] _ in
            guard let self else { return }
            updateMessageUnReadNum()
        }.store(in: &cancellables)
    }

    @objc private func didTapMiddleButton(sender: UIButton) {
        let optionViewController = GGLPublishOptionViewController()
        optionViewController.modalPresentationStyle = .fullScreen
        AppRouter.shared.present(optionViewController)
    }

}
