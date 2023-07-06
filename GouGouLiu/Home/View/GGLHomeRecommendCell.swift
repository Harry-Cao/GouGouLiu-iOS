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
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemGray
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
        [imageView, titleLabel].forEach(addSubview)
        imageView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(8)
            make.height.equalTo(40)
        }
    }

    func setup(model: GGLHomePostModel_Data) {
        let url = URL(string: model.cover_image_preview ?? "")
        imageView.sd_setImage(with: url)
        titleLabel.text = model.post_title
    }

}
