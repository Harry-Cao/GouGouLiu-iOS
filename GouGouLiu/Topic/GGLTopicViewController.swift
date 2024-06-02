//
//  GGLTopicViewController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/6.
//

import UIKit
import Combine
import Hero

final class GGLTopicViewController: GGLBaseViewController {

    var postModel: GGLHomePostModel? {
        didSet {
            viewModel.postModel = postModel
        }
    }
    var photoBrowserCellHeroID: String?
    var coverImage: UIImage?
    private let viewModel = GGLTopicViewModel()
    private let adapter = GGLTopicAdapter()
    private let transitionHelper = GGLHeroTransitionHelper()
    private let topicTableView = GGLBaseTableView()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupUI()
        setupAdapter()
        bindData()
        getData()
    }

    private func setupNavigationItem() {
        navigationItem.leftBarButtonItem = barButtonItem(navigationItem: .image(UIImage(resource: .navigationBarBack), #selector(didTapBackButton)))
        navigationItem.rightBarButtonItems = barButtonItems(items: [.avatar(postModel?.user?.avatarUrl ?? "", #selector(didTapUser)),
                                                                    .text(postModel?.user?.userName ?? "", #selector(didTapUser))])
    }

    private func setupUI() {
        [topicTableView].forEach(view.addSubview)
        topicTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        transitionHelper.delegate = self
    }

    private func setupAdapter() {
        adapter.tableView = topicTableView
        adapter.photoBrowserCellConfigurator = { [weak self] cell in
            guard let self else { return }
            cell.heroID = photoBrowserCellHeroID
            let imageModels = viewModel.postModel?.post?.photos?.map({ GGLWebImageModel(imageUrl: $0.originalUrl, previewUrl: $0.previewUrl) }) ?? [GGLWebImageModel(placeholderImage: coverImage)]
            cell.setup(imageModels: imageModels, failToGestures: [transitionHelper.leftGesture])
        }
        adapter.contentCellConfigurator = { [weak self] cell in
            cell.setup(title: self?.viewModel.postModel?.post?.title, content: self?.viewModel.postModel?.post?.content)
        }
        adapter.photoBrowserCellDidSelectHandler = { [weak self] _, index in
            guard let urlString = self?.viewModel.postModel?.post?.photos?[index].originalUrl else { return }
            self?.downloadImage(urlString: urlString)
        }
    }

    private func downloadImage(urlString: String) {
        UIAlertController.popupConfirmAlert(title: "确认下载图片？") {
            GGLPhotoDownloadManager.shared.downloadPhotosToAlbum(urls: [urlString], progress:  { receivedSize, expectedSize in
                ProgressHUD.showProgress(CGFloat(receivedSize)/CGFloat(expectedSize))
            }, completed:  { allSuccess, failUrlStrings in
                ProgressHUD.showSucceed()
            })
        }
    }

    private func bindData() {
        viewModel.$postModel.sink { [weak self] _ in
            self?.topicTableView.reloadData()
        }.store(in: &cancellables)
    }

    private func getData() {
        viewModel.getPostData()
    }

    @objc private func didTapBackButton() {
        transitionHelper.dismiss()
    }

    @objc private func didTapUser() {
        guard let user = viewModel.postModel?.user else { return }
        let viewController = GGLPersonalDetailViewController(user: user)
        AppRouter.shared.push(viewController)
    }

}

// MARK: - GGLHeroTransitionHelperDelegate
extension GGLTopicViewController: GGLHeroTransitionHelperDelegate {
    func transitionHelperNeedRightEdgeGesture() -> Bool {
        false
    }

    func transitionHelperGestureViewController() -> UIViewController? {
        return navigationController
    }
}
