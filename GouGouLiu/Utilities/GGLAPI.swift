//
//  URLPath.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/7/8.
//

import Foundation

struct GGLAPI {
    static var host: String {
        UserDefaults.host.rawValue
    }
    static var baseURL: URL {
        URL(string: host)!
    }
}

extension GGLAPI {
    enum Host: String, CaseIterable {
        case internet = "http://f3.ttvt.cc:15791"
        case intranet = "http://192.168.0.211:8888"
        case localhost = "http://localhost:8888"
    }
}
