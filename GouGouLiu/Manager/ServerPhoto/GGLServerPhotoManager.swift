//
//  GGLServerPhotoManager.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/17/23.
//

import Foundation
import Moya
import RxSwift

final class GGLServerPhotoManager {

    static let shared = GGLServerPhotoManager()
    private let moyaProvider = MoyaProvider<GGLUploadPhotoAPI>()
    private(set) var disposeBag = DisposeBag()

    func uploadPhoto(data: Data, type: ImageType, contactId: String) -> Observable<GGLUploadPhotoModel> {
        let api = GGLUploadPhotoAPI(imageData: data, imageType: type.rawValue, contactId: contactId)
        return Observable<GGLUploadPhotoModel>.ofRequest(api: api, provider: moyaProvider)
    }

    func clearAllPhotos() -> Observable<GGLBaseMoyaModel> {
        let api = GGLClearAllPhotoAPI()
        return Observable<GGLBaseMoyaModel>.ofRequest(api: api, provider: MoyaProvider<GGLClearAllPhotoAPI>())
    }

}

extension GGLServerPhotoManager {

    enum ImageType: Int {
        case avatar
        case post
    }

}
