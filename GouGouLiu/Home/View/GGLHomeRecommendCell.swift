//
//  GGLHomeRecommendCell.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/6.
//

import UIKit

final class GGLHomeRecommendCell: UICollectionViewCell {

    private let imageView: UIImageView = UIImageView()

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
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func setup() {
        let url = URL(string: "http://192.168.0.123:88//appIcon.png")
        imageView.sd_setImage(with: url)
    }

}
