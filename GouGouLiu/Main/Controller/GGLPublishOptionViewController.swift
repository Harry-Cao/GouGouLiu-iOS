//
//  GGLPublishOptionViewController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/24/23.
//

import UIKit

final class GGLPublishOptionViewController: GGLBaseViewController {

    private let publishPostButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.setBackgroundImage(.publish_post, for: .normal)
        return button
    }()
    private let publishOrderButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.setBackgroundImage(.publish_order, for: .normal)
        return button
    }()
    private let containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        return stackView
    }()
    private let foldUpButton: UIButton = {
        let button = UIButton()
        button.setImage(.tab_bar_fold_up, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hero.isEnabled = true
        setupUI()
    }

    private func setupUI() {
        [publishPostButton, publishOrderButton].forEach(containerView.addArrangedSubview)
        [foldUpButton, containerView].forEach(view.addSubview)
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(foldUpButton.snp.top).offset(-36)
            make.height.equalTo(200)
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

    @objc private func didTapFoldUp() {
        dismiss(animated: true)
    }

    @objc private func didTapPublishPost() {
        dismiss(animated: true) {
            AppRouter.shared.push(GGLPostViewController())
        }
    }

    @objc private func didTapPublishOrder() {
        dismiss(animated: true) {
            
        }
    }

}
