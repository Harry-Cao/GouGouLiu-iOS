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
            data.append(MultipartFormData(provider: .data(imageData), name: "image_data", fileName: "GGL_Img.jpeg", mimeType: "image/jpeg"))
        }
        if let imageType = imageType {
            let valueData = String(imageType).multipartFormData(name: "image_type")
            data.append(valueData)
        }
        if let contactId = contactId {
            let valueData = contactId.multipartFormData(name: "contact_id")
            data.append(valueData)
        }
        return .uploadMultipart(data)
    }
    
    var headers: [String : String]? {
        nil
    }

}
