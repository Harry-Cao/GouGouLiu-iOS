//
//  GGLTopicViewController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/6.
//

import UIKit

final class GGLTopicViewController: GGLBaseViewController {

    var postModel: GGLHomePostModel?
    private(set) var previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = .Topic
        setupUI()
        setupData()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true)
    }

    private func setupUI() {
        [previewImageView].forEach(view.addSubview)
        previewImageView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(400)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCoverImageView))
        previewImageView.addGestureRecognizer(tapGesture)
    }

    private func setupData() {
        guard let coverUrl = postModel?.postImages else { return }
        let url = URL(string: coverUrl)
        previewImageView.sd_setImage(with: url)
    }

    @objc private func didTapCoverImageView() {
        let alertController = UIAlertController(title: "确认下载图片？", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "确定", style: .default) { _ in
            guard let coverUrl = self.postModel?.postImages else { return }
            GGLPhotoDownloadManager.shared.downloadPhotosToAlbum(urls: [coverUrl], progress:  { receivedSize, expectedSize in
                ProgressHUD.showProgress(CGFloat(receivedSize)/CGFloat(expectedSize))
            }, completed:  { allSuccess, failUrlStrings in
                ProgressHUD.showSucceed()
            })
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        [confirmAction, cancelAction].forEach(alertController.addAction)
        present(alertController, animated: true)
    }

}
