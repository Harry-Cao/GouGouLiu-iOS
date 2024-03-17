//
//  UITabBarController+GGL.swift
//  GouGouLiu
//
//  Created by Harry Cao on 3/17/24.
//

import Foundation

extension UITabBarController {
    var tabBarButtons: [UIView] {
        let tabBarButtons = tabBar.subviews.filter({ $0.frame.width < UIScreen.main.bounds.width })
        let sortedButtons = tabBarButtons.sorted(by: { $0.frame.minX < $1.frame.minX })
        return sortedButtons
    }
}
