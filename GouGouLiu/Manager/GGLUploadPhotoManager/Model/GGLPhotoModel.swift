//
//  GGLPhotoModel.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/18/23.
//

import RealmSwift

final class GGLPhotoModel: Object, Codable {
    let id: UInt?
    @Persisted var originalUrl: String?
    @Persisted var previewUrl: String?

    static func create(url: String?) -> GGLPhotoModel {
        let model = GGLPhotoModel()
        model.originalUrl = url
        model.previewUrl = url
        return model
    }
}
