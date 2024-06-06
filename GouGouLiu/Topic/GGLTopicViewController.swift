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

    private let photoBrowserCellHeroID: String?
    private let viewModel: GGLTopicViewModel
    private let adapter = GGLTopicAdapter()
    private let transitionHelper = GGLHeroTransitionHelper()
    private let topicTableView = GGLBaseTableView()
    private var cancellables = Set<AnyCancellable>()

    init(postModel: GGLHomePostModel, coverImage: UIImage?, photoBrowserCellHeroID: String?) {
        self.photoBrowserCellHeroID = photoBrowserCellHeroID
        self.viewModel = GGLTopicViewModel(postModel: postModel, coverImage: coverImage)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        navigationItem.rightBarButtonItems = barButtonItems(items: [.avatar(viewModel.postModel.user?.avatarUrl ?? "", #selector(didTapUser)), .text(viewModel.postModel.user?.userName ?? "", #selector(didTapUser))])
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
            cell.browserView.delegate = self
            cell.setup(imageModels: viewModel.imageModels, failToGestures: [transitionHelper.dismissGesture], height: viewModel.browserCellHeight)
        }
        adapter.contentCellConfigurator = { [weak self] cell in
            cell.setup(title: self?.viewModel.postModel.post?.title, content: self?.viewModel.postModel.post?.content)
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
        guard let user = viewModel.postModel.user else { return }
        let viewController = GGLPersonalDetailViewController(user: user)
        AppRouter.shared.push(viewController)
    }

}

// MARK: - GGLWebImageBrowserDelegate
extension GGLTopicViewController: GGLWebImageBrowserDelegate {
    func imageBrowserView(_ imageBrowserView: GGLWebImageBrowser, didSelectItemAt index: Int) {
        guard let urlString = viewModel.postModel.post?.photos?[index].originalUrl else { return }
        downloadImage(urlString: urlString)
    }

    func imageBrowserView(_ imageBrowserView: GGLWebImageBrowser, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: mainWindow.bounds.width, height: viewModel.browserCellHeight)
    }
}

// MARK: - GGLHeroTransitionHelperDelegate
extension GGLTopicViewController: GGLHeroTransitionHelperDelegate {
    func transitionHelperNeedDismissGesture() -> Bool { true }

    func transitionHelperNeedPresentGesture() -> Bool { false }

    func transitionHelperGestureViewController() -> UIViewController? {
        return navigationController
    }
}
