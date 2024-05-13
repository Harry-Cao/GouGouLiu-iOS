//
//  GGLPostViewController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/24/23.
//

import UIKit
import Combine

final class GGLPostViewController: GGLBaseViewController {

    private let viewModel = GGLPostViewModel()
    private var cancellables = Set<AnyCancellable>()
    private var adapter = GGLPostAdapter()
    private let postTableView = GGLBaseTableView()
    private let publishButton: UIButton = {
        let button = UIButton()
        button.setTitle("发布", for: .normal)
        button.layer.cornerRadius = 23
        button.layer.masksToBounds = true
        button.backgroundColor = .theme_color
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = .Post
        bindData()
        setupUI()
        setupAdapter()
    }

    private func bindData() {
        viewModel.delegate = self
        viewModel.uploadPhotosSubject.sink { [weak self] _ in
            self?.reloadUploadPhotoCell()
        }.store(in: &cancellables)
    }

    private func setupUI() {
        [postTableView, publishButton].forEach(view.addSubview)
        postTableView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalTo(publishButton.snp.top)
        }
        publishButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.snp.bottomMargin).inset(12)
            make.height.equalTo(46)
        }
        publishButton.addTarget(self, action: #selector(didTapPublishButton), for: .touchUpInside)
    }

    private func setupAdapter() {
        adapter.tableView = postTableView
        adapter.uploadPhotoCellConfigurator = { [weak self] uploadPhotoCell in
            guard let self else { return }
            let urlStrings = viewModel.uploadPhotosSubject.value.compactMap({ $0.previewUrl })
            uploadPhotoCell.urlStrings = urlStrings
        }
        adapter.uploadPhotoCellSelectedHandler = { [weak self] urlString in
            if let urlString {
                ProgressHUD.show("该功能暂不支持\n\(urlString)", icon: .message)
            } else {
                self?.viewModel.uploadPhoto()
            }
        }
    }

    private func reloadUploadPhotoCell() {
        guard let item = adapter.cellTypes.firstIndex(of: .uploadPhoto) else { return }
        postTableView.reloadRows(at: [IndexPath(item: item, section: 0)], with: .none)
    }

    @objc private func didTapPublishButton() {
        viewModel.publishPost()
    }

}

// MARK: - GGLPostViewModelDelegate
extension GGLPostViewController: GGLPostViewModelDelegate {
    func didPublishPost(post: GGLPostModel?) {
        navigationController?.popViewController(animated: true)
    }
}
