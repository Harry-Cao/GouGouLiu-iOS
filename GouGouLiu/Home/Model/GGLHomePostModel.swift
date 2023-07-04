//
//  GGLHomePostModel.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/7/5.
//

import Foundation

struct GGLHomePostModel: Codable {

    var data: [GGLHomePostModel_Data]?
    var update_time: String?

}

struct GGLHomePostModel_Data: Codable {

    var cover_image: String?
    var post_title: String?
    var update_time: String?

}
