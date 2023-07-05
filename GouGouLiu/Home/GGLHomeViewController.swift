//
//  GGLHomeViewController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/5.
//

import UIKit
import Hero
import RxSwift

final class GGLHomeViewController: GGLBaseViewController {

    private let viewModel = GGLHomeViewModel()
    private let itemSpacing: CGFloat = 4.0
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

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = .Home
        setupUI()
        bindData()
        getData()
    }

    private func setupUI() {
        [recommendCollectionView].forEach(view.addSubview)
        recommendCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func bindData() {
        viewModel.updateSubject.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.recommendCollectionView.reloadData()
        }).disposed(by: viewModel.disposeBag)
    }

    private func getData() {
        viewModel.getHomePostData()
    }

}

// MARK: - UICollectionViewDataSource
extension GGLHomeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(GGLHomeRecommendCell.self)", for: indexPath) as? GGLHomeRecommendCell
        let model = viewModel.dataSource[indexPath.item]
        cell?.setup(model: model)
        return cell ?? UICollectionViewCell()
    }

}

// MARK: - UICollectionViewDelegate
extension GGLHomeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let heroId = "\(Date())"
        cell?.hero.id = heroId
        let model = viewModel.dataSource[indexPath.item]
        let viewController = GGLTopicViewController()
        viewController.postModel = model
        let navigationController = GGLBaseNavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.hero.isEnabled = true
        navigationController.view.hero.id = heroId
        AppRouter.shared.present(navigationController)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y > 1 {
            hideNavigationBar()
        } else if velocity.y < -1 {
            showNavigationBar()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentOffset.y < 5 else { return }
        showNavigationBar()
    }

    private func showNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    private func hideNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

}

// MARK: - GGLWaterFallFlowLayout
extension GGLHomeViewController: GGLWaterFallFlowLayoutDelegate {

    func waterFlowLayout(_ waterFlowLayout: GGLWaterFallFlowLayout, itemHeight indexPath: IndexPath) -> CGFloat {
        CGFloat(arc4random_uniform(400 - 200) + 200)
    }

}



