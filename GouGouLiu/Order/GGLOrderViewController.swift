//
//  GGLOrderViewController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/7/5.
//

import UIKit
import SnapKit
import Combine

final class GGLOrderViewController: GGLBaseViewController {
    private let viewModel = GGLOrderViewModel()
    private var cancellables = Set<AnyCancellable>()

    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        return layout
    }()
    private lazy var orderCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(GGLOrderCell.self, forCellWithReuseIdentifier: "\(GGLOrderCell.self)")
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = .Order
        setupUI()
        bindData()
        viewModel.mockData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        flowLayout.sectionInset = UIEdgeInsets(top: viewModel.sectionInset.top,
                                               left: viewModel.sectionInset.left + mainWindow.safeAreaInsets.left,
                                               bottom: viewModel.sectionInset.bottom,
                                               right: viewModel.sectionInset.right + mainWindow.safeAreaInsets.right)
    }

    private func setupUI() {
        view.addSubview(orderCollectionView)
        orderCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func bindData() {
        viewModel.$dataSource.sink { [weak self] data in
            guard let self else { return }
            orderCollectionView.reloadData()
        }.store(in: &cancellables)
    }
}

// MARK: - UICollectionViewDataSource
extension GGLOrderViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = viewModel.dataSource[indexPath.row]
        let cell: GGLOrderCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.setup(model: model)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension GGLOrderViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: viewModel.itemWidth, height: 100.0)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
