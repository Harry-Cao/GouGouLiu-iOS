//
//  AppDelegate.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/5.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupAppearance()
        GGLNetworkManager.shared.startListening()
        GGLWebSocketManager.shared.startSubscribe()
        loginWithUserId()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    private func setupAppearance() {
        // UITabBar
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.unselectedItemTintColor = .secondaryLabel
        tabBarAppearance.tintColor = .label
        /// tabBar遮挡到内容时的背景色
        tabBarAppearance.barTintColor = .systemBackground
        /// 滚动到底部时的背景色
        tabBarAppearance.backgroundColor = .systemBackground
        /// 隐藏分割线
        tabBarAppearance.backgroundImage = UIImage()
        tabBarAppearance.shadowImage = UIImage()

        // UINavigationBar
        let navBarAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label,
                                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold)]
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .systemBackground
        navigationBarAppearance.titleTextAttributes = navBarAttributes
        let navigationBarBack = UIImage(resource: .navigationBarBack)
        navigationBarAppearance.setBackIndicatorImage(navigationBarBack, transitionMaskImage: navigationBarBack)
        /// 将navigationBar的底部分割线设为透明
        navigationBarAppearance.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        /// navigationBar上其他控件的颜色，例如返回按钮
        UINavigationBar.appearance().tintColor = .label

        // UITableView
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
    }

    private func loginWithUserId() {
        guard let userId = UserDefaults.userId else { return }
        GGLUser.login(userId: userId)
    }

}

