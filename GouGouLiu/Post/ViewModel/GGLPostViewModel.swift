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

    var uploadPhotoUrls = [String]()
    private let moyaProvider = MoyaProvider<GGLPostAPI>()
    private let disposeBag = DisposeBag()
    private(set) var uploadSubject = PublishSubject<Any?>()

    func uploadPhoto() {
        guard let userId = GGLUser.getUserId() else { return }
        GGLUploadPhotoManager.shared.pickImage { image in
            guard let data = image?.fixOrientation().jpegData(compressionQuality: 1) else { return }
            GGLUploadPhotoManager.shared.uploadPhoto(data: data, type: .post, contactId: userId, progressBlock: { progress in
                ProgressHUD.showServerProgress(progress: progress.progress)
            }).observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] model in
                if model.code == .success, let url = model.data?.url {
                    self?.uploadPhotoUrls.append(url)
                    self?.uploadSubject.onNext(nil)
                }
                ProgressHUD.showServerMsg(model: model)
            }).disposed(by: GGLUploadPhotoManager.shared.disposeBag)
        }
    }

    func publishPost() {
        guard let userId = GGLUser.getUserId() else { return }
        guard !uploadPhotoUrls.isEmpty else {
            ProgressHUD.showFailed("请上传至少一张图片")
            return
        }
        let title = GGLPostManager.shared.cacheTitle ?? ""
        let content = GGLPostManager.shared.cacheContent
        requestPublishPost(userId: userId, imageUrls: uploadPhotoUrls, title: title, content: content).subscribe(onNext: { model in
            ProgressHUD.showServerMsg(model: model)
        }).disposed(by: disposeBag)
    }

    private func requestPublishPost(userId: String, imageUrls: [String], title: String, content: String?) -> Observable<GGLMoyaModel<GGLPostModel>> {
        let api = GGLPostAPI(userId: userId, imageUrls: imageUrls, title: title, content: content)
        return .ofRequest(api: api, provider: moyaProvider)
    }

}
