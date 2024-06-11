//
//  GGLPostUploadPhotoContentCell.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/26/23.
//

import UIKit

final class GGLPostUploadPhotoContentCell: UICollectionViewCell {

    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .opaqueSeparator
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(photoImageView)
        photoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func setupEmpty() {
        photoImageView.contentMode = .center
        photoImageView.image = UIImage(resource: .iconAdd)
    }

    func setup(urlString: String) {
        photoImageView.contentMode = .scaleAspectFill
        let url = URL(string: urlString)
        photoImageView.sd_setImage(with: url)
    }

}
