//
//  GGLUploadPhotoManager.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/17/23.
//

import Foundation
import Moya
import Combine

extension GGLUploadPhotoManager {
    typealias ImageBlock = (_ image: UIImage?) -> Void
}

final class GGLUploadPhotoManager: NSObject, UINavigationControllerDelegate {

    static let shared = GGLUploadPhotoManager()
    private var finishPickingMediaBlock: ImageBlock?
    private let moyaProvider = MoyaProvider<GGLPhotoAPI>()
    private var cancellables = Set<AnyCancellable>()

    func uploadPhoto(data: Data,
                     type: ImageType,
                     contactId: String,
                     progressBlock: ((_ progress: Double) -> Void)? = nil,
                     completion: @escaping (GGLMoyaModel<GGLPhotoModel>) -> Void) {
        moyaProvider.requestWithProgressPublisher(.upload(imageData: data, imageType: type.rawValue, contactId: contactId))
            .mapProgressResponse(GGLMoyaModel<GGLPhotoModel>.self)
            .receive(on: DispatchQueue.main)
            .sinkWithDefaultErrorHandle(receiveValue: { progressResponse in
                switch progressResponse {
                case .onProgress(let progress):
                    progressBlock?(progress)
                case .onResponse(let response):
                    completion(response)
                }
            }).store(in: &cancellables)
    }

    func clearAllPhotos() {
        guard let userId = GGLUser.getUserId() else { return }
        moyaProvider.requestPublisher(.clearAll(userId: userId))
            .map(GGLMoyaModel<[String: String]>.self)
            .receive(on: DispatchQueue.main)
            .sinkWithDefaultErrorHandle(receiveValue: { model in
                ProgressHUD.showServerMsg(model: model)
            }).store(in: &cancellables)
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

    enum ImageType: UInt {
        case avatar
        case post
        case chat
        case petPhoto
    }

}
