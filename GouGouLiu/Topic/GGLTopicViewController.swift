//
//  GGLTopicViewController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/6.
//

import UIKit
import RxSwift
import Hero

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
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupUI()
        setupAdapter()
        bindData()
        getData()
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
        transitionHelper.delegate = self
    }

    private func setupAdapter() {
        adapter.tableView = topicTableView
        adapter.photoBrowserCellConfigurator = { [weak self] cell in
            guard let self else { return }
            let failToGestures = [transitionHelper.leftGesture, transitionHelper.rightGesture]
            guard let urlStrings = viewModel.postModel?.post?.photos else {
                cell.setup(urlStrings: [viewModel.postModel?.post?.coverImageUrl ?? ""], failToGestures: failToGestures)
                return
            }
            cell.setup(urlStrings: urlStrings, failToGestures: failToGestures)
        }
        adapter.contentCellConfigurator = { [weak self] cell in
            cell.setup(title: self?.viewModel.postModel?.post?.title, content: self?.viewModel.postModel?.post?.content)
        }
        adapter.photoBrowserCellDidSelectHandler = { [weak self] _, index in
            guard let urlString = self?.viewModel.postModel?.post?.photos?[index] else { return }
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
        viewModel.updateSubject.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] model in
            self?.topicTableView.reloadData()
        }).disposed(by: disposeBag)
    }

    private func getData() {
        viewModel.getPostData()
    }

    @objc private func didTapBackButton() {
        self.dismiss(animated: true)
    }

    override func transitionHelperPresentViewController() -> UIViewController? {
        guard let user = viewModel.postModel?.user else { return nil }
        return GGLPersonalDetailViewController(user: user)
    }

    override func transitionHelperDismissAnimationType() -> HeroDefaultAnimationType { .none }

}
