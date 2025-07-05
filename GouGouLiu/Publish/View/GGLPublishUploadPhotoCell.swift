//
//  GGLPublishUploadPhotoCell.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/26/23.
//

import UIKit

protocol GGLPublishUploadPhotoCellDelegate: AnyObject {
    func didSelectItem(urlString: String?)
}

final class GGLPublishUploadPhotoCell: GGLBaseTableViewCell {

    private let itemSize: CGFloat = 128.0

    weak var delegate: GGLPublishUploadPhotoCellDelegate?
    var urlStrings: [String] = [] {
        didSet {
            uploadPhotoCollectionView.reloadData()
        }
    }
    private lazy var uploadPhotoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(GGLPublishUploadPhotoContentCell.self)
        return collectionView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(uploadPhotoCollectionView)
        uploadPhotoCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(itemSize)
        }
    }

}

// MARK: - UICollectionViewDataSource
extension GGLPublishUploadPhotoCell: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urlStrings.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: GGLPublishUploadPhotoContentCell = collectionView.dequeueReusableCell(for: indexPath)
        if let urlString = urlStrings[safe: indexPath.item] {
            cell.setup(urlString: urlString)
        } else {
            cell.setupEmpty()
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let urlString = urlStrings[safe: indexPath.item]
        delegate?.didSelectItem(urlString: urlString)
    }

}

// MARK: - UICollectionViewFlowLayout
extension GGLPublishUploadPhotoCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemSize, height: itemSize)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
}
