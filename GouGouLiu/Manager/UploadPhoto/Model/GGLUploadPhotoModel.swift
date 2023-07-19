//
//  GGLUploadPhotoModel.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/18/23.
//

import Foundation

struct GGLUploadPhotoModel: Codable {
    var code: Int?
    var data: GGLUploadPhotoModel_Data?
    var msg: String?
}

struct GGLUploadPhotoModel_Data: Codable {
    var url: String?
}
