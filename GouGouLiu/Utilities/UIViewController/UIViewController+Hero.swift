//
//  UIViewController+Hero.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/18.
//

import Foundation
import Hero

extension UIViewController {
    func setHeroModalAnimationType(_ type: HeroDefaultAnimationType) {
        self.isHeroEnabled = true
        self.heroModalAnimationType = type
        self.modalPresentationStyle = .overFullScreen
    }
}
