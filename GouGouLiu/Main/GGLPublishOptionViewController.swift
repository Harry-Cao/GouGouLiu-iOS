//
//  GGLPublishOptionViewController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/24/23.
//

import UIKit

final class GGLPublishOptionViewController: GGLBaseViewController {

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
        [foldUpButton].forEach(view.addSubview)
        foldUpButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(24)
            make.size.equalTo(CGSize(width: 84, height: 84))
        }
        foldUpButton.addTarget(self, action: #selector(didTapFoldUp), for: .touchUpInside)
    }

    @objc private func didTapFoldUp() {
        dismiss(animated: true)
    }

}
