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
        self.hero.isEnabled = true
        self.heroModalAnimationType = type
        self.modalPresentationStyle = .fullScreen
    }
}
