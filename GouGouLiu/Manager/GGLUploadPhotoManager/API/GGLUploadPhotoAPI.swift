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
    var contactId: String?

    var baseURL: URL {
        GGLAPI.baseURL
    }
    
    var path: String {
        GGLAPI.Path.uploadPhoto
    }
    
    var method: Moya.Method {
        .post
    }
    
    var task: Moya.Task {
        var data = [MultipartFormData]()
        if let imageData = imageData {
            data.append(MultipartFormData(provider: .data(imageData), name: "imageData", fileName: "GGL_Img.jpeg", mimeType: "image/jpeg"))
        }
        if let imageType = imageType {
            let valueData = String(imageType).multipartFormData(name: "imageType")
            data.append(valueData)
        }
        if let contactId = contactId {
            let valueData = contactId.multipartFormData(name: "contactId")
            data.append(valueData)
        }
        return .uploadMultipart(data)
    }
    
    var headers: [String : String]? {
        nil
    }

}
