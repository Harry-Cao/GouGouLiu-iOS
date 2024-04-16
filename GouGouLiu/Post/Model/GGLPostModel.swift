//
//  GGLPostModel.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/26/23.
//

import Foundation

struct GGLPostModel: Codable {
    var postId: String?
    var userId: String?
    var coverImageUrl: String?
    var photos: [String]?
    var title: String?
    var content: String?
    var createTime: String?
    var updateTime: String?
}
