//
//  GGLHomeViewController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/5.
//

import UIKit

final class GGLHomeViewController: GGLBaseViewController {

    private lazy var recommendCollectionView: UICollectionView = {
        let waterFallFlowLayout = GGLWaterFallFlowLayout()
        waterFallFlowLayout.minimumInteritemSpacing = itemSpacing
        waterFallFlowLayout.sectionInset = UIEdgeInsets(top: itemSpacing, left: itemSpacing, bottom: itemSpacing, right: itemSpacing)
        waterFallFlowLayout.delegate = self
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: waterFallFlowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(GGLHomeRecommendCell.self, forCellWithReuseIdentifier: "\(GGLHomeRecommendCell.self)")
        return collectionView
    }()
    private let itemSpacing: CGFloat = 4.0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = .Home
        setupUI()
    }

    private func setupUI() {
        [recommendCollectionView].forEach(view.addSubview)
        recommendCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

// MARK: - UICollectionViewDataSource
extension GGLHomeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(GGLHomeRecommendCell.self)", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }

}

// MARK: - UICollectionViewDelegate
extension GGLHomeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = GGLTopicViewController()
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }

}

// MARK: - GGLWaterFallFlowLayout
extension GGLHomeViewController: GGLWaterFallFlowLayoutDelegate {

    func waterFlowLayout(_ waterFlowLayout: GGLWaterFallFlowLayout, itemHeight indexPath: IndexPath) -> CGFloat {
        CGFloat(arc4random_uniform(400 - 200) + 200)
    }

}



