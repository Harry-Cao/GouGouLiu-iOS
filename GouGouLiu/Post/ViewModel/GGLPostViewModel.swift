//
//  GGLPostViewModel.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/24/23.
//

import UIKit
import Combine
import Moya

protocol GGLPostViewModelDelegate: AnyObject {
    func didPublishPost(post: GGLPostModel?)
}

final class GGLPostViewModel {

    weak var delegate: GGLPostViewModelDelegate?
    private let networkHelper = GGLPostNetworkHelper()
    @Published private(set) var uploadPhotos = [GGLUploadPhotoModel]()

    func uploadPhoto() {
        guard let userId = GGLUser.getUserId() else { return }
        GGLUploadPhotoManager.shared.pickImage { image in
            guard let data = image?.fixOrientation().jpegData(compressionQuality: 1) else { return }
            GGLUploadPhotoManager.shared.uploadPhoto(data: data, type: .post, contactId: userId) { progress in
                ProgressHUD.showServerProgress(progress: progress)
            } completion: { [weak self] model in
                if let self, model.code == .success, let photo = model.data {
                    uploadPhotos.append(photo)
                }
                ProgressHUD.showServerMsg(model: model)
            }
        }
    }

    func publishPost() {
        guard let userId = GGLUser.getUserId() else { return }
        guard let coverUrl = uploadPhotos.first?.previewUrl else {
            ProgressHUD.showFailed("请上传至少一张图片")
            return
        }
        let title = GGLPostManager.shared.cacheTitle ?? ""
        let content = GGLPostManager.shared.cacheContent
        networkHelper.requestPublishPost(userId: userId, coverUrl: coverUrl, imageUrls: uploadPhotos.compactMap({ $0.originalUrl }), title: title, content: content) { [weak self] model in
            if model.code == .success {
                self?.delegate?.didPublishPost(post: model.data)
            }
            ProgressHUD.showServerMsg(model: model)
        }
    }

}
