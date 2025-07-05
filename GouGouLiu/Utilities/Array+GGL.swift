//
//  Array+GGL.swift
//  GouGouLiu
//
//  Created by HarryCao on 2025/7/5.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
