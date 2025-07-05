//
//  GGLPersonalHeaderView.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/9/15.
//

import UIKit
import SDWebImage
import SnapKit

protocol GGLPersonalHeaderViewDelegate: AnyObject {
    func didTapAvatar()
}

final class GGLPersonalHeaderView: UIView {
    weak var delegate: GGLPersonalHeaderViewDelegate?
    static let normalHeight: CGFloat = 400.0
    private let avatarSize = CGSize(width: 84, height: 84)
    private let coverImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = .lightGray
        return view
    }()
    private let container = UIView()
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayerOffset: CGFloat = 150
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(origin: CGPoint(x: .zero, y: -gradientLayerOffset),
                                     size: CGSize(width: mainWindow.bounds.width, height: gradientLayerOffset + avatarSize.height/2))
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        return gradientLayer
    }()
    private let whitePanel: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    private let avatarButton: UIButton = {
        let view = UIButton()
        view.imageView?.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 42
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        view.backgroundColor = .lightGray.withAlphaComponent(0.5)
        return view
    }()
    private let nameLabel = UILabel()
    private let userIdLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateGradientViewColor()
    }

    private func setupUI() {
        [coverImageView, container].forEach(addSubview)
        [whitePanel, avatarButton, nameLabel, userIdLabel].forEach(container.addSubview)
        coverImageView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }
        container.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(avatarButton)
        }
        whitePanel.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(coverImageView.snp.bottom)
            make.height.equalTo(64)
        }
        avatarButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(avatarSize)
            make.centerY.equalTo(whitePanel.snp.top)
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarButton.snp.trailing).offset(8)
            make.top.equalTo(avatarButton).offset(12)
        }
        userIdLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarButton.snp.trailing).offset(8)
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
        }
        avatarButton.addTarget(self, action: #selector(didTapAvatar), for: .touchUpInside)
        container.layer.insertSublayer(gradientLayer, at: 0)
    }

    private func updateGradientViewColor() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.systemBackground.cgColor]
    }

    @objc private func didTapAvatar() {
        delegate?.didTapAvatar()
    }

    func setup(user: GGLUserModel?) {
        coverImageView.sd_setImage(with: URL(string: user?.avatar?.previewUrl ?? ""))
        avatarButton.sd_setImage(with: URL(string: user?.avatar?.previewUrl ?? ""), for: .normal)
        nameLabel.text = user?.userName
        userIdLabel.text = user?.userId
    }
}
