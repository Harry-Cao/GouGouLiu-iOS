//
//  GGLPostViewModel.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/24/23.
//

import UIKit

final class GGLPostViewModel {

    private var uploadPhotoUrls = [String]()

    func uploadPhoto() {
        guard let userId = GGLUser.getUserId() else { return }
        GGLUploadPhotoManager.shared.pickImage { image in
            guard let data = image?.jpegData(compressionQuality: 1) else { return }
            GGLUploadPhotoManager.shared.uploadPhoto(data: data, type: .post, contactId: userId).subscribe(onNext: { [weak self] model in
                if model.code == .success, let url = model.data?.url {
                    self?.uploadPhotoUrls.append(url)
                }
                ProgressHUD.showServerMsg(model: model)
            }).disposed(by: GGLUploadPhotoManager.shared.disposeBag)
        }
    }

    func publishPost() {
        guard let userId = GGLUser.getUserId() else { return }
        requestPublishPost(userId: userId)
    }

    private func requestPublishPost(userId: String) {
        
    }

}
