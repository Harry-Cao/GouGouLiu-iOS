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
        button.backgroundColor = .systemYellow.withAlphaComponent(0.8)
        return button
    }()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = .Post
        bindData()
        setupUI()
        setupAdapter()
    }

    private func bindData() {
        viewModel.uploadSubject.subscribe(onNext: { [weak self] _ in
            self?.reloadUploadPhotoCell()
        }).disposed(by: disposeBag)
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
        adapter.uploadPhotoCellConfiguration = { [weak self] uploadPhotoCell in
            guard let urlStrings = self?.viewModel.uploadPhotoUrls else { return }
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
