//
//  UIImage.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/6.
//

import UIKit

extension UIImage {

    static var navigation_bar_back: UIImage? { UIImage(named: "navigation_bar_back") }
    static var navigation_bar_logo: UIImage? { UIImage(named: "gougouliu_logo") }

    static var tab_bar_home_normal: UIImage? { UIImage(named: "tab_bar_home_normal") }
    static var tab_bar_home_selected: UIImage? { UIImage(named: "tab_bar_home_selected") }
    static var tab_bar_services_normal: UIImage? { UIImage(named: "tab_bar_services_normal") }
    static var tab_bar_services_selected: UIImage? { UIImage(named: "tab_bar_services_selected") }
    static var tab_bar_message_normal: UIImage? { UIImage(named: "tab_bar_message_normal") }
    static var tab_bar_message_selected: UIImage? { UIImage(named: "tab_bar_message_selected") }
    static var tab_bar_personal_normal: UIImage? { UIImage(named: "tab_bar_personal_normal") }
    static var tab_bar_personal_selected: UIImage? { UIImage(named: "tab_bar_personal_selected") }
    static var tab_bar_extension: UIImage? { UIImage(named: "tab_bar_extension") }
    static var tab_bar_fold_up: UIImage? { UIImage(named: "tab_bar_fold_up") }

    static var icon_add: UIImage? { UIImage(named: "icon_add") }
    static var icon_empty_data: UIImage? { UIImage(named: "empty_data")?.withTintColor(.label) }
    static var publish_order: UIImage? { UIImage(named: "publish_order") }
    static var publish_post: UIImage? { UIImage(named: "publish_post") }
    
}

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
