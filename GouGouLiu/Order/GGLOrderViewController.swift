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

    private lazy var orderCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = viewModel.sectionInset
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
        orderCollectionView.reloadData()
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(GGLOrderCell.self)", for: indexPath) as? GGLOrderCell else {
            fatalError("OrderTableView could not get GGLOrderCell at indexPath \(indexPath)")
        }
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
