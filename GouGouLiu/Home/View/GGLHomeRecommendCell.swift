//
//  GGLHomeRecommendCell.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/6.
//

import UIKit

final class GGLHomeRecommendCell: UICollectionViewCell {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private let mainStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        view.alignment = .leading
        return view
    }()
    private let userInfoStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 6
        view.alignment = .center
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .label
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .secondaryLabel
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
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.backgroundColor = .secondarySystemBackground
        [imageView, mainStackView].forEach(addSubview)
        [titleLabel, userInfoStackView].forEach(mainStackView.addArrangedSubview)
        [avatarImageView, nameLabel].forEach(userInfoStackView.addArrangedSubview)
        setupConstraints()
    }

    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }
        mainStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.equalTo(imageView.snp.bottom).offset(12)
            make.bottom.equalToSuperview().inset(8)
        }
        avatarImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
    }

    func setup(model: GGLHomePostModel) {
        let coverUrl = URL(string: model.postImages?.first ?? "")
        imageView.sd_setImage(with: coverUrl)
        if let postTitle = model.postTitle, !postTitle.isEmpty {
            titleLabel.isHidden = false
            titleLabel.text = postTitle
        } else {
            titleLabel.isHidden = true
        }
        let avatarUrl = URL(string: model.userAvatar ?? "")
        avatarImageView.sd_setImage(with: avatarUrl)
        nameLabel.text = model.userName
    }

}
