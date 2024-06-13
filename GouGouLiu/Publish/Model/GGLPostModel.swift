//
//  GGLPostModel.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/26/23.
//

import Foundation

struct GGLPostModel: Codable {
    let postId: String?
    let userId: String?
    let coverImageUrl: String?
    let photoIds: [UInt]?
    let photos: [GGLPhotoModel]?
    let title: String?
    let content: String?
    let createTime: String?
    let updateTime: String?
}
