//
//  GGLPhotoAPI.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/5/13.
//

import Foundation
import Moya

enum GGLPhotoAPI: TargetType {
    case upload(imageData: Data?, imageType: UInt?, contactId: String?)
    case clearAll(userId: String)

    var baseURL: URL {
        GGLAPI.baseURL
    }

    var path: String {
        switch self {
        case .upload:
            return "/api/photo/upload"
        case .clearAll:
            return "/api/photo/clearAll"
        }
    }

    var method: Moya.Method {
        switch self {
        case .upload,
                .clearAll:
            return .post
        }
    }

    var task: Moya.Task {
        switch self {
        case .upload(let imageData, let imageType, let contactId):
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
        case .clearAll(let userId):
            let para: [String: Any] = ["userId": userId]
            return .requestParameters(parameters: para, encoding: JSONEncoding.default)
        }
    }

    var headers: [String : String]? {
        nil
    }
}
