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
    private let detailContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .label
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
        [imageView, detailContainer].forEach(addSubview)
        [titleLabel, avatarImageView, nameLabel].forEach(detailContainer.addSubview)
        imageView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalTo(detailContainer.snp.top)
        }
        detailContainer.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.equalToSuperview().inset(12)
            make.height.equalTo(30)
        }
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(12)
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.bottom.equalToSuperview().inset(8)
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(6)
            make.centerY.equalTo(avatarImageView)
            make.trailing.equalToSuperview().inset(12)
        }
    }

    func setup(model: GGLHomePostModel) {
        let coverUrl = URL(string: model.postImages?.first ?? "")
        imageView.sd_setImage(with: coverUrl)
        titleLabel.text = model.postTitle
        let avatarUrl = URL(string: model.userAvatar ?? "")
        avatarImageView.sd_setImage(with: avatarUrl)
        nameLabel.text = model.userName
    }

}
