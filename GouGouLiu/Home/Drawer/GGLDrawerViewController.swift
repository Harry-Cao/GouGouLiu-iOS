//
//  GGLDrawerViewController.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/6/12.
//

import Foundation

final class GGLDrawerViewController: GGLBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        let containerView = UIView()
        containerView.backgroundColor = .systemBackground
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.setTitle("DEBUG", for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        view.addSubview(containerView)
        containerView.addSubview(button)
        containerView.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(mainWindow.bounds.width * 2 / 3)
        }
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.dismiss(animated: true)
    }

    @objc private func didTapButton() {
        AppRouter.shared.push(GGLDebugViewController())
    }
}
