//
//  GGLUploadPhotoManager.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/17/23.
//

import Foundation
import Moya
import RxSwift

extension GGLUploadPhotoManager {
    typealias ImageBlock = (_ image: UIImage?) -> Void
}

final class GGLUploadPhotoManager: NSObject, UINavigationControllerDelegate {

    static let shared = GGLUploadPhotoManager()
    private var finishPickingMediaBlock: ImageBlock?

    func uploadPhoto(data: Data, type: ImageType, contactId: String, progressBlock: ProgressBlock? = nil) -> Observable<GGLMoyaModel<GGLUploadPhotoModel>> {
        let api = GGLUploadPhotoAPI(imageData: data, imageType: type.rawValue, contactId: contactId)
        return MoyaProvider<GGLUploadPhotoAPI>().observable.request(api, progressBlock: progressBlock)
    }

    func clearAllPhotos() {
        guard let userId = GGLUser.getUserId() else { return }
        let _ = requestClearAllPhotos(userId: userId).subscribe(onNext: { model in
            ProgressHUD.showServerMsg(model: model)
        })
    }

    func requestClearAllPhotos(userId: String)  -> Observable<GGLMoyaModel<[String: String]>> {
        let api = GGLClearAllPhotoAPI(userId: userId)
        return MoyaProvider<GGLClearAllPhotoAPI>().observable.request(api)
    }

    func pickImage(completion: @escaping ImageBlock) {
        ProgressHUD.show()
        finishPickingMediaBlock = completion
        let imagePickerViewController = UIImagePickerController()
        imagePickerViewController.delegate = self
        AppRouter.shared.present(imagePickerViewController) {
            ProgressHUD.dismiss()
        }
    }

}

// MARK: - UIImagePickerControllerDelegate
extension GGLUploadPhotoManager: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [weak self] in
            let image = info[.originalImage] as? UIImage
            self?.finishPickingMediaBlock?(image)
        }
    }

}

extension GGLUploadPhotoManager {

    enum ImageType: Int {
        case avatar
        case post
        case chat
    }

}
