//
//  UIViewController+NavigationItem.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/19.
//

import Foundation

extension UIViewController {
    func setupRightNavigationItems(_ items: [GGLNavigationItem]) {
        let stackView = UIStackView()
        stackView.spacing = 8
        let views = items.map({ viewFromNavigationItem($0) })
        views.forEach(stackView.addArrangedSubview)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: stackView)
    }

    func viewFromNavigationItem(_ item: GGLNavigationItem) -> UIView {
        switch item {
        case .image(let url, let action):
            let button = UIButton()
            button.sd_setImage(with: URL(string: url), for: .normal)
            button.imageView?.contentMode = .scaleAspectFill
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 12
            if let action {
                button.addTarget(self, action: action, for: .touchUpInside)
            }
            button.snp.makeConstraints { make in
                make.size.equalTo(24)
            }
            return button
        case .text(let text, let action):
            let label = UILabel()
            label.text = text
            label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            if let action {
                label.isUserInteractionEnabled = true
                let tapGesture = UITapGestureRecognizer(target: self, action: action)
                label.addGestureRecognizer(tapGesture)
            }
            return label
        case .systemImage(let name, let action):
            let button = UIButton()
            button.setImage(UIImage(systemName: name), for: .normal)
            if let action {
                button.addTarget(self, action: action, for: .touchUpInside)
            }
            button.snp.makeConstraints { make in
                make.size.equalTo(24)
            }
            return button
        }
    }

    enum GGLNavigationItem {
        case image(_ url: String, _ action: Selector?)
        case text(_ text: String, _ action: Selector?)
        case systemImage(_ name: String, _action: Selector?)
    }
}
