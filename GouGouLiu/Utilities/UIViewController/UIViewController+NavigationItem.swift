//
//  UIViewController+NavigationItem.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/19.
//

import UIKit
import SDWebImage

extension UIViewController {
    func barButtonItems(items: [GGLNavigationItem]) -> [UIBarButtonItem] {
        items.map({ barButtonItem(navigationItem: $0) })
    }

    func barButtonItem(navigationItem: GGLNavigationItem) -> UIBarButtonItem {
        switch navigationItem {
        case .avatar(let url, let action):
            let button = UIButton()
            button.sd_setImage(with: URL(string: url), for: .normal, placeholderImage: UIImage(resource: .defaultAvatar))
            button.imageView?.contentMode = .scaleAspectFill
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 12
            if let action {
                button.addTarget(self, action: action, for: .touchUpInside)
            }
            button.snp.makeConstraints { make in
                make.size.equalTo(24)
            }
            return UIBarButtonItem(customView: button)
        case .text(let text, let action):
            let label = UILabel()
            label.text = text
            label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            if let action {
                label.isUserInteractionEnabled = true
                let tapGesture = UITapGestureRecognizer(target: self, action: action)
                label.addGestureRecognizer(tapGesture)
            }
            return UIBarButtonItem(customView: label)
        case .image(let image, let action):
            return UIBarButtonItem(image: image, style: .plain, target: self, action: action)
        }
    }

    enum GGLNavigationItem {
        case avatar(_ url: String, _ action: Selector?)
        case text(_ text: String, _ action: Selector?)
        case image(_ image: UIImage?, _ action: Selector?)
    }
}
