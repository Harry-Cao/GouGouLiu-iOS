//
//  GGLServerPhotoManager.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/17/23.
//

import Foundation
import Moya
import RxSwift
import ProgressHUD

extension GGLServerPhotoManager {
    typealias ImageBlock = (_ image: UIImage?) -> Void
}

final class GGLServerPhotoManager: NSObject, UINavigationControllerDelegate {

    static let shared = GGLServerPhotoManager()
    private var finishPickingMediaBlock: ImageBlock?
    private let moyaProvider = MoyaProvider<GGLUploadPhotoAPI>()
    private(set) var disposeBag = DisposeBag()

    func uploadPhoto(data: Data, type: ImageType, contactId: String) -> Observable<GGLUploadPhotoModel> {
        let api = GGLUploadPhotoAPI(imageData: data, imageType: type.rawValue, contactId: contactId)
        return Observable<GGLUploadPhotoModel>.ofRequest(api: api, provider: moyaProvider)
    }

    func clearAllPhotos() {
        guard let userId = GGLUser.current.getUserId() else { return }
        requestClearAllPhotos(userId: userId).subscribe(onNext: { model in
            if model.code == 0 {
                ProgressHUD.showSucceed(model.msg)
            }
        }).disposed(by: disposeBag)
    }

    func requestClearAllPhotos(userId: String)  -> Observable<GGLBaseMoyaModel> {
        let api = GGLClearAllPhotoAPI(userId: userId)
        return Observable<GGLBaseMoyaModel>.ofRequest(api: api, provider: MoyaProvider<GGLClearAllPhotoAPI>())
    }

    func pickImage(completion: @escaping ImageBlock) {
        finishPickingMediaBlock = completion
        let imagePickerViewController = UIImagePickerController()
        imagePickerViewController.delegate = self
        AppRouter.shared.present(imagePickerViewController)
    }

}

// MARK: - UIImagePickerControllerDelegate
extension GGLServerPhotoManager: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [weak self] in
            let image = info[.originalImage] as? UIImage
            self?.finishPickingMediaBlock?(image)
        }
    }

}

extension GGLServerPhotoManager {

    enum ImageType: Int {
        case avatar
        case post
    }

}
