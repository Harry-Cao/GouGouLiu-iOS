//
//  GGLPostModel.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/26/23.
//

import Foundation

struct GGLPostModel: Codable {
    let postId: String?
    let owner: GGLUserModel?
    let coverImageUrl: String?
    let photos: [GGLPhotoModel]?
    let title: String?
    let content: String?
    let createTime: String?
    let updateTime: String?
}
