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
    private let coverImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = .lightGray
        return view
    }()
    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    private let avatarButton: UIButton = {
        let view = UIButton()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 42
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
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

    private func setupUI() {
        [coverImageView, container].forEach(addSubview)
        [avatarButton, nameLabel, userIdLabel].forEach(container.addSubview)
        coverImageView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }
        container.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(coverImageView.snp.bottom)
            make.height.equalTo(100)
        }
        avatarButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(84)
            make.centerY.equalTo(container.snp.top)
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(avatarButton).offset(8)
            make.centerX.greaterThanOrEqualTo(avatarButton)
            make.top.equalTo(avatarButton.snp.bottom).offset(12)
        }
        userIdLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarButton.snp.trailing).offset(8)
            make.bottom.equalTo(avatarButton).inset(8)
        }
        avatarButton.addTarget(self, action: #selector(didTapAvatar), for: .touchUpInside)
    }

    @objc private func didTapAvatar() {
        delegate?.didTapAvatar()
    }

    func setup(user: GGLUserModel?) {
        coverImageView.sd_setImage(with: URL(string: user?.avatarUrl ?? ""))
        avatarButton.sd_setImage(with: URL(string: user?.avatarUrl ?? ""), for: .normal, placeholderImage: UIImage(resource: .defaultAvatar))
        nameLabel.text = user?.userName
        userIdLabel.text = "userId: \(user?.userId ?? "")"
    }
}
