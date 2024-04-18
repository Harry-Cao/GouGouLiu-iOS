//
//  UIViewController+GGL.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/18.
//

import Foundation

extension UIViewController {
    var isPresented: Bool {
        if let navigationController = self.navigationController {
            if navigationController.viewControllers.first == self, let _ = navigationController.presentingViewController {
                return true
            }
            return false
        }
        return presentingViewController != nil
    }
}
