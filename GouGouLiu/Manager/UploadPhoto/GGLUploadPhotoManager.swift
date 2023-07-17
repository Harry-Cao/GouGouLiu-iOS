//
//  GGLUploadPhotoManager.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/17/23.
//

import Foundation
import Moya
import RxSwift

final class GGLUploadPhotoManager {

    static let shared = GGLUploadPhotoManager()
    private let moyaProvider = MoyaProvider<GGLUploadPhotoAPI>()
    private(set) var disposeBag = DisposeBag()

    func uploadPhoto(data: Data, type: ImageType) -> Observable<GGLUploadPhotoModel> {
        let api = GGLUploadPhotoAPI(imageData: data, imageType: type.rawValue)
        return Observable<GGLUploadPhotoModel>.ofRequest(api: api, provider: moyaProvider)
    }

}

extension GGLUploadPhotoManager {

    enum ImageType: Int {
        case avatar
        case post
    }

}
