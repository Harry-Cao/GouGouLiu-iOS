//
//  GGLUploadPhotoModel.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/18/23.
//

import Foundation

struct GGLUploadPhotoModel: Codable {
    var ret: Int?
    var data: GGLUploadPhotoModel_data?
}

struct GGLUploadPhotoModel_data: Codable {
    var url: String?
}
