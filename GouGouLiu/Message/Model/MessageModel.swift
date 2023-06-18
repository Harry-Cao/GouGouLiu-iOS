//
//  MessageModel.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/18.
//

import Foundation

struct MessageModel: Identifiable {
    let id = UUID()
    var name: String
    var message: String
}
