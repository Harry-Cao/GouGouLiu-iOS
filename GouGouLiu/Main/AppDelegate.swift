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
        UITabBar.appearance().unselectedItemTintColor = .secondaryLabel
        UITabBar.appearance().tintColor = .label
        /// tabBar遮挡到内容时的背景色
        UITabBar.appearance().barTintColor = .systemBackground
        /// 滚动到底部时的背景色
        UITabBar.appearance().backgroundColor = .systemBackground

        // UINavigationBar
        let navBarAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label,
                                NSAttributedString.Key.font: UIFont.navigation_bar_title]
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = navBarAttributes
        appearance.setBackIndicatorImage(.navigation_bar_back, transitionMaskImage: .navigation_bar_back)
        /// 将navigationBar的底部分割线设为透明
        appearance.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().isTranslucent = false
        /// navigationBar上其他控件的颜色，例如返回按钮
        UINavigationBar.appearance().tintColor = .label

        // UITableView
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
    }


}

