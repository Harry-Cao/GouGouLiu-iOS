//
//  UIColor+GGL.swift
//  GouGouLiu
//
//  Created by Harry Cao on 3/20/24.
//

import Foundation

extension UIColor {

    static var theme_color: UIColor? { .systemYellow.withAlphaComponent(0.9) }

}

extension UIColor {
    convenience init?(hex: String) {
        guard hex.hasPrefix("#"), hex.count == 7 else { return nil }
        let start = hex.index(hex.startIndex, offsetBy: 1)
        let hexColor = String(hex[start...])
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0

        if scanner.scanHexInt64(&hexNumber) {
            let red = CGFloat((hexNumber & 0xFF0000) >> 16)
            let green = CGFloat((hexNumber & 0x00FF00) >> 8)
            let blue = CGFloat((hexNumber & 0x0000FF))
            self.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1)
            return
        }

        return nil
    }
}
