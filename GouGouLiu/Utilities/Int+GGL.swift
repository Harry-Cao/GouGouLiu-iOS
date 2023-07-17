//
//  Int+GGL.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/17/23.
//

import Foundation
import Moya

extension Int {

    func multipartFormData(name: String) -> MultipartFormData {
        let valueData = String(self).data(using: .utf8) ?? Data()
        return MultipartFormData(provider: .data(valueData), name: name)
    }

}
