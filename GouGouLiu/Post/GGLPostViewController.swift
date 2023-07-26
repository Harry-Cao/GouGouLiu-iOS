//
//  GGLPostViewController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/24/23.
//

import UIKit
import RxSwift

final class GGLPostViewController: GGLBaseViewController {

    private let viewModel = GGLPostViewModel()
    private var adapter = GGLPostAdapter()
    private lazy var postTableView = GGLBaseTableView()
    private let publishButton: UIButton = {
        let button = UIButton()
        button.setTitle("发布", for: .normal)
        button.layer.cornerRadius = 23
        button.layer.masksToBounds = true
        button.backgroundColor = .systemGreen.withAlphaComponent(0.5)
        return button
    }()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = .Post
        setupUI()
        setupAdapter()
    }

    private func setupUI() {
        [postTableView, publishButton].forEach(view.addSubview)
        postTableView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalTo(publishButton.snp.top)
        }
        publishButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.snp.bottomMargin)
            make.height.equalTo(46)
        }
        publishButton.addTarget(self, action: #selector(didTapPublishButton), for: .touchUpInside)
    }

    private func setupAdapter() {
        adapter.tableView = postTableView
        adapter.uploadPhotoCellConfiguration = { [weak self] uploadPhotoCell in
            guard let urlStrings = self?.viewModel.uploadPhotoUrls else { return }
            uploadPhotoCell.urlStrings = urlStrings
        }
        adapter.uploadPhotoCellSelectedHandler = { [weak self] urlString in
            if let urlString {
                ProgressHUD.show("该功能暂不支持\n\(urlString)", icon: .message)
            } else {
                guard let userId = GGLUser.getUserId() else { return }
                GGLUploadPhotoManager.shared.pickImage { image in
                    guard let data = image?.jpegData(compressionQuality: 1) else { return }
                    GGLUploadPhotoManager.shared.uploadPhoto(data: data, type: .post, contactId: userId)
                        .observe(on: MainScheduler.instance)
                        .subscribe(onNext: { model in
                        if model.code == .success, let urlString = model.data?.url {
                            self?.viewModel.uploadPhotoUrls.append(urlString)
                            self?.reloadUploadPhotoCell()
                        }
                        ProgressHUD.showServerMsg(model: model)
                    }).disposed(by: GGLUploadPhotoManager.shared.disposeBag)
                }
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
