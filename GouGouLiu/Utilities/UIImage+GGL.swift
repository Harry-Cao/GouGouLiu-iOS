//
//  UIImage.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/6.
//

import UIKit

extension UIImage {

    func fixOrientation() -> UIImage {
        if imageOrientation == .up {
            // 如果图片方向已经正确，直接返回原图
            return self
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        draw(in: rect)
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return normalizedImage
    }

}
