//
//  GGLHomePostModel.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/7/5.
//

import Foundation

struct GGLHomePostModel: Codable {

    var code: Int?
    var msg: String?
    var data: [GGLHomePostModel_Data]?

}

struct GGLHomePostModel_Data: Codable {

    var user_name: String?
    var user_avatar: String?
    var cover_image: String?
    var cover_image_preview: String?
    var post_title: String?
    var update_time: String?

}
