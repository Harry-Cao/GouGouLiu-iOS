//
//  GGLTopicViewController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/6.
//

import UIKit

final class GGLTopicViewController: GGLBaseViewController {

    var postModel: GGLHomePostModel? {
        didSet {
            viewModel.postModel = postModel
            topicTableView.reloadData()
        }
    }
    private let viewModel = GGLTopicViewModel()
    private let adapter = GGLTopicAdapter()
    private let topicTableView = GGLBaseTableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupUI()
        setupAdapter()
    }

    private func setupNavigationItem() {
        navigationItem.title = .Topic
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: .navigation_bar_back, style: .plain, target: self, action: #selector(didTapBackButton))
    }

    private func setupUI() {
        topicTableView.bounces = false
        [topicTableView].forEach(view.addSubview)
        topicTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupAdapter() {
        adapter.tableView = topicTableView
        adapter.photoBrowserCellConfigurator = { [weak self] cell in
            guard let urlStrings = self?.viewModel.postModel?.postImages else { return }
            cell.setup(urlStrings: urlStrings)
        }
        adapter.contentCellConfigurator = { [weak self] cell in
            cell.setup(title: self?.viewModel.postModel?.postTitle, content: self?.viewModel.postModel?.postContent)
        }
        adapter.photoBrowserCellDidSelectHandler = { [weak self] _, index in
            guard let urlString = self?.viewModel.postModel?.postImages?[index] else { return }
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

    @objc private func didTapBackButton() {
        self.dismiss(animated: true)
    }

}
