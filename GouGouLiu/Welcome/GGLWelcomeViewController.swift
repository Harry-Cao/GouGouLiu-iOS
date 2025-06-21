//
//  GGLWelcomeViewController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 3/13/24.
//

import UIKit
import SnapKit

final class GGLWelcomeViewController: GGLBaseViewController {
    private let backgroundView = UIView()
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor.theme_color.withAlphaComponent(0.7).cgColor,
            UIColor.theme_color.cgColor
        ]
        layer.locations = [0.0, 1.0]
        return layer
    }()
    private lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        return view
    }()
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 32
        return stackView
    }()
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 12
        return stackView
    }()
    private lazy var headingLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to \(String.app_english_name)"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Join over 10.000 learners over the World and enjoy online education!"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 12
        return stackView
    }()
    private lazy var createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create an account", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .white
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(createAccountTapped), for: .touchUpInside)
        return button
    }()
    private lazy var signInStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    private lazy var alreadyHaveAccountLabel: UILabel = {
        let label = UILabel()
        label.text = "Already have an account?"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        return label
    }()
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log in", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        return button
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = backgroundView.bounds
    }

    private func setupUI() {
        backgroundView.layer.addSublayer(gradientLayer)
        [backgroundView, overlayView, contentStackView].forEach(view.addSubview)
        [headingLabel, subtitleLabel].forEach(textStackView.addArrangedSubview)
        [alreadyHaveAccountLabel, loginButton].forEach(signInStackView.addArrangedSubview)
        [createAccountButton, signInStackView].forEach(buttonStackView.addArrangedSubview)
        [textStackView, buttonStackView].forEach(contentStackView.addArrangedSubview)
        setupConstraints()
    }

    private func setupConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
        }
        textStackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        buttonStackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        createAccountButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
    }

    @objc private func createAccountTapped() {
        AppRouter.shared.push(GGLLoginViewController())
    }

    @objc private func loginTapped() {
        AppRouter.shared.push(GGLLoginViewController())
    }
}
