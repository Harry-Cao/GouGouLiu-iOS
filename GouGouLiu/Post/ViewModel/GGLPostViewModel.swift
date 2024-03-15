//
//  GGLPostViewModel.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/24/23.
//

import UIKit
import RxSwift
import Moya

final class GGLPostViewModel {

    var uploadPhotos = [GGLUploadPhotoModel]()
    private let moyaProvider = MoyaProvider<GGLPostAPI>()
    private let clearAllMoyaProvider = MoyaProvider<GGLClearAllPostAPI>()
    private(set) var uploadSubject = PublishSubject<Any?>()
    private(set) var publishSubject = PublishSubject<Any?>()

    func uploadPhoto() {
        guard let userId = GGLUser.getUserId() else { return }
        GGLUploadPhotoManager.shared.pickImage { image in
            guard let data = image?.fixOrientation().jpegData(compressionQuality: 1) else { return }
            let _ = GGLUploadPhotoManager.shared.uploadPhoto(data: data, type: .post, contactId: userId, progressBlock: { progress in
                ProgressHUD.showServerProgress(progress: progress.progress)
            }).subscribe(onNext: { [weak self] model in
                if model.code == .success, let photo = model.data {
                    self?.uploadPhotos.append(photo)
                    self?.uploadSubject.onNext(nil)
                }
                ProgressHUD.showServerMsg(model: model)
            }, onError: { error in
                ProgressHUD.showFailed(error.localizedDescription)
            })
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
        let _ = requestPublishPost(userId: userId, coverUrl: coverUrl, imageUrls: uploadPhotos.compactMap({ $0.originalUrl }), title: title, content: content).subscribe(onNext: { [weak self] model in
            if model.code == .success {
                self?.publishSubject.onNext(nil)
            }
            ProgressHUD.showServerMsg(model: model)
        })
    }

    private func requestPublishPost(userId: String, coverUrl: String, imageUrls: [String], title: String, content: String?) -> Observable<GGLMoyaModel<GGLPostModel>> {
        let api = GGLPostAPI(userId: userId, coverUrl: coverUrl, imageUrls: imageUrls, title: title, content: content)
        return .ofRequest(api: api, provider: moyaProvider)
    }

    func clearAllPost(userId: String) -> Observable<GGLMoyaModel<GGLPostModel>> {
        let api = GGLClearAllPostAPI(userId: userId)
        return .ofRequest(api: api, provider: MoyaProvider<GGLClearAllPostAPI>())
    }

}
