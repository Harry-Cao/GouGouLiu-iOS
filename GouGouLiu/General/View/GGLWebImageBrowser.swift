//
//  GGLWebImageBrowser.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/29/23.
//

import UIKit

protocol GGLWebImageBrowserDelegate: AnyObject {
    func imageBrowserView(_ imageBrowserView: GGLWebImageBrowser, didSelectItemAt index: Int)
}

final class GGLWebImageBrowser: UIView {

    private var configuration = GGLWebImageBrowserConfiguration()
    weak var delegate: GGLWebImageBrowserDelegate?
    var imageModels: [GGLWebImageModel] = [] {
        didSet {
            imageCollectionView.reloadData()
        }
    }
    var failToGestures: [UIGestureRecognizer]? {
        didSet {
            guard let failToGestures else { return }
            failToGestures.forEach { gestureRecognizer in
                imageCollectionView.panGestureRecognizer.require(toFail: gestureRecognizer)
            }
        }
    }

    private lazy var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(GGLWebImageBrowserCell.self, forCellWithReuseIdentifier: "\(GGLWebImageBrowserCell.self)")
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    init(configuration: GGLWebImageBrowserConfiguration) {
        super.init(frame: .zero)
        self.configuration = configuration
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        [imageCollectionView].forEach(addSubview)
        imageCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(configuration.imageHeight)
        }
    }

}

// MARK: - UICollectionViewDataSource
extension GGLWebImageBrowser: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: GGLWebImageBrowserCell = collectionView.dequeueReusableCell(for: indexPath)
        let imageModel = imageModels[indexPath.item]
        cell.setup(imageModel: imageModel)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.imageBrowserView(self, didSelectItemAt: indexPath.item)
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension GGLWebImageBrowser: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: configuration.imageWidth, height: configuration.imageHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}

final class GGLWebImageBrowserConfiguration {

    var imageWidth: CGFloat = mainWindow.bounds.width
    var imageHeight: CGFloat = mainWindow.bounds.width

}

// MARK: - GGLWebImageBrowserCell
final class GGLWebImageBrowserCell: UICollectionViewCell {

    private let previewImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    private let originalImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        [previewImageView, originalImageView].forEach(addSubview)
        previewImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        originalImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func setup(imageModel: GGLWebImageModel) {
        previewImageView.sd_setImage(with: URL(string: imageModel.placeholderUrl ?? ""), placeholderImage: imageModel.placeholderImage)
        originalImageView.sd_setImage(with: URL(string: imageModel.imageUrl ?? ""))
    }

}

struct GGLWebImageModel {
    var imageUrl: String? = nil
    var placeholderUrl: String? = nil
    var placeholderImage: UIImage? = nil
}
