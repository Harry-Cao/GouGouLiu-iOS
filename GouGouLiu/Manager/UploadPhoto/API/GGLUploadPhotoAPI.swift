//
//  GGLUploadPhotoAPI.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/17/23.
//

import Foundation
import Moya

struct GGLUploadPhotoAPI: TargetType {

    var imageData: Data?
    var imageType: Int?

    var baseURL: URL {
        .api_baseURL
    }
    
    var path: String {
        .path_uploadPhoto
    }
    
    var method: Moya.Method {
        .post
    }
    
    var task: Moya.Task {
        var data = [MultipartFormData]()
        if let imageData = imageData {
            data.append(MultipartFormData(provider: .data(imageData), name: "image_data"))
        }
        if let imageType = imageType {
            let valueData = imageType.multipartFormData(name: "image_type")
            data.append(valueData)
        }
        return .uploadMultipart(data)
    }
    
    var headers: [String : String]? {
        nil
    }

}
