//
//  GGLPublishOptionViewController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/24/23.
//

import UIKit
import Hero

final class GGLPublishOptionViewController: GGLBaseViewController {

    private lazy var publishPostButton: UIButton = createButton(title: "发帖子", image: UIImage(resource: .publishPost))
    private lazy var publishOrderButton: UIButton = createButton(title: "发订单", image: UIImage(resource: .publishOrder))
    private let containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    private let foldUpButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .tabBarFoldUp), for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hero.isEnabled = true
        setupUI()
    }

    private func setupUI() {
        [publishPostButton, publishOrderButton].forEach { view in
            containerView.addArrangedSubview(view)
            view.snp.makeConstraints { make in
                make.height.equalTo(84)
            }
        }
        [foldUpButton, containerView].forEach(view.addSubview)
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(foldUpButton.snp.top).offset(-36)
        }
        foldUpButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(24)
            make.size.equalTo(CGSize(width: 84, height: 84))
        }
        foldUpButton.addTarget(self, action: #selector(didTapFoldUp), for: .touchUpInside)
        publishPostButton.addTarget(self, action: #selector(didTapPublishPost), for: .touchUpInside)
        publishOrderButton.addTarget(self, action: #selector(didTapPublishOrder), for: .touchUpInside)
    }

    private func createButton(title: String?, image: UIImage?) -> UIButton {
        let button = UIButton()
        button.hero.modifiers = [.fade, .scale(0.5)]
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.setTitle(title, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.setImage(image, for: .normal)
        button.backgroundColor = .theme_color
        return button
    }

    @objc private func didTapFoldUp() {
        dismiss(animated: true)
    }

    @objc private func didTapPublishPost() {
        dismiss(animated: true) {
            AppRouter.shared.push(GGLPublishViewController())
        }
    }

    @objc private func didTapPublishOrder() {
        dismiss(animated: true) {
            
        }
    }

}
