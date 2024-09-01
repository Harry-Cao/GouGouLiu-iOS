//
//  GGLOrderCell.swift
//  GouGouLiu
//
//  Created by harry.weixian.cao on 2024/8/27.
//

import Foundation
import SnapKit
import SDWebImage

final class GGLOrderCell: UICollectionViewCell {
    static let minWidth: CGFloat = 300.0
    private let container: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    private let infoLabel = UILabel()
    private let requirementLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
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
        let layoutGuide = UILayoutGuide()
        contentView.addLayoutGuide(layoutGuide)
        contentView.addSubview(container)
        [avatarImageView, infoLabel, requirementLabel].forEach(container.addSubview)
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        avatarImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(avatarImageView.snp.height)
        }
        layoutGuide.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(8)
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.centerY.equalToSuperview()
        }
        infoLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(layoutGuide)
        }
        requirementLabel.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(8)
            make.leading.bottom.trailing.equalTo(layoutGuide)
        }
    }

    func setup(model: GGLOrderModel) {
        let avatarUrl = model.pets?.first?.avatarUrl ?? ""
        avatarImageView.sd_setImage(with: URL(string: avatarUrl))
        infoLabel.text = model.pets?.first?.name
        requirementLabel.text = model.requirements
    }
}
