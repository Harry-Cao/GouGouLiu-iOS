//
//  GGLPhotoAPI.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/5/13.
//

import Foundation
import Moya

enum GGLPhotoAPI: TargetType {
    case upload(imageData: Data, imageType: UInt, contactId: String)
    case clearAll(userId: String)

    var baseURL: URL {
        GGLAPI.baseURL
    }

    var path: String {
        switch self {
        case .upload:
            return "/api/photo/upload/"
        case .clearAll:
            return "/api/photo/clearAll/"
        }
    }

    var method: Moya.Method {
        switch self {
        case .upload:
            return .post
        case .clearAll:
            return .delete
        }
    }

    var task: Moya.Task {
        switch self {
        case .upload(let imageData, let imageType, let contactId):
            var data = [MultipartFormData]()
            data.append(MultipartFormData(provider: .data(imageData), name: "imageData", fileName: "\(contactId)-\(UUID()).jpeg", mimeType: "image/jpeg"))
            data.append(contactId.multipartFormData(name: "contactId"))
            data.append(String(imageType).multipartFormData(name: "imageType"))
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
