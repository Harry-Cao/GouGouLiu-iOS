//
//  GGLHomeViewController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/5.
//

import UIKit
import Combine
import MJRefresh
import Hero

final class GGLHomeViewController: GGLBaseViewController {
    private let viewModel = GGLHomeViewModel()
    private var cancellables = Set<AnyCancellable>()
    private lazy var emptyDataView = GGLEmptyDataView()
    private lazy var drawerTransition = GGLDrawerTransition()
    private lazy var recommendCollectionView: UICollectionView = {
        let itemSpacing: CGFloat = 4.0
        let waterFallFlowLayout = GGLWaterFallFlowLayout()
        waterFallFlowLayout.minimumInteritemSpacing = itemSpacing
        waterFallFlowLayout.sectionInset = UIEdgeInsets(top: itemSpacing, left: itemSpacing, bottom: itemSpacing, right: itemSpacing)
        waterFallFlowLayout.delegate = self
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: waterFallFlowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(GGLHomeRecommendCell.self, forCellWithReuseIdentifier: "\(GGLHomeRecommendCell.self)")
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        isHeroEnabled = true
        navigationItem.leftBarButtonItem = barButtonItem(navigationItem: .image(UIImage(resource: .gougouliuLogo), #selector(showDebugPage)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(openDrawer))
        setupUI()
        setupRefreshComponent()
        bindData()
        onNetworkStatus()
    }

    private func setupUI() {
        [recommendCollectionView].forEach(view.addSubview)
        recommendCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupRefreshComponent() {
        let header = MJRefreshGifHeader { [weak self] in
            self?.viewModel.getHomePostData()
        }
        header.lastUpdatedTimeLabel?.isHidden = true
        header.stateLabel?.isHidden = true
        header.setImages(viewModel.refreshImages, for: .idle)
        header.setImages(viewModel.refreshImages, for: .refreshing)
        header.link(to: recommendCollectionView)
    }

    private func bindData() {
        viewModel.$dataSource.sink { [weak self] data in
            guard let self else { return }
            recommendCollectionView.reloadData()
        }.store(in: &cancellables)
        viewModel.requestCompletion.sink { [weak self] completion in
            guard let self else { return }
            recommendCollectionView.mj_header?.endRefreshing()
            switch completion {
            case .finished:
                dismissEmptyDataView()
            case .failure:
                guard viewModel.dataSource.isEmpty else { return }
                showEmptyDataView(target: self)
            }
        }.store(in: &cancellables)
    }

    private func onNetworkStatus() {
        GGLNetworkManager.shared.$networkStatus.sink { [weak self] status in
            // 处理首次启动app网络请求时机问题
            guard let self,
                  viewModel.dataSource.isEmpty else { return }
            switch status {
            case .reachable:
                refreshData()
            default:
                break
            }
        }.store(in: &cancellables)
    }

    @objc private func refreshData() {
        recommendCollectionView.mj_header?.beginRefreshing()
    }

    @objc private func showDebugPage() {
        #if DEBUG
        AppRouter.shared.push(GGLDebugViewController())
        #endif
    }
}

extension GGLHomeViewController {
    func showEmptyDataView(target: GGLEmptyDataViewDelegate) {
        emptyDataView.delegate = target
        view.addSubview(emptyDataView)
        emptyDataView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func dismissEmptyDataView() {
        emptyDataView.delegate = nil
        emptyDataView.removeFromSuperview()
    }
}

// MARK: - GGLEmptyDataViewDelegate
extension GGLHomeViewController: GGLEmptyDataViewDelegate {
    func didTapRefresh() {
        refreshData()
    }
}

// MARK: - UICollectionViewDataSource
extension GGLHomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: GGLHomeRecommendCell = collectionView.dequeueReusableCell(for: indexPath)
        let model = viewModel.dataSource[indexPath.item]
        cell.setup(model: model)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension GGLHomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = viewModel.dataSource[indexPath.item]
        let heroID = String(Date().timeIntervalSince1970)
        let coverHeroID = "\(heroID)-cover"
        let cell = collectionView.cellForItem(at: indexPath) as? GGLHomeRecommendCell
        cell?.heroID = heroID
        cell?.imageView.heroID = coverHeroID
        let viewController = GGLTopicViewController(postModel: model, coverImage: cell?.imageView.image, photoBrowserCellHeroID: coverHeroID)
        let navigationController = GGLBaseNavigationController(rootViewController: viewController)
        navigationController.setHeroModalAnimationType(.auto)
        navigationController.view.heroID = heroID
        AppRouter.shared.present(navigationController) {
            navigationController.isHeroEnabled = false
        }
    }
}

// MARK: - GGLWaterFallFlowLayout
extension GGLHomeViewController: GGLWaterFallFlowLayoutDelegate {
    func waterFlowLayout(_ waterFlowLayout: GGLWaterFallFlowLayout, itemHeight indexPath: IndexPath) -> CGFloat {
        CGFloat.random(in: 250...350)
    }
}

// MARK: - GGLDrawerViewController
extension GGLHomeViewController {
    @objc private func openDrawer() {
        let drawerViewController = GGLDrawerViewController()
        let navigationController = GGLBaseNavigationController(rootViewController: drawerViewController)
        navigationController.transitioningDelegate = drawerTransition
        navigationController.modalPresentationStyle = .custom
        AppRouter.shared.present(navigationController)
    }
}



