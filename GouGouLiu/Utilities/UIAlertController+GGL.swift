//
//  UIAlertController+GGL.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/21/23.
//

import Foundation

extension UIAlertController {

    static func popupAccountInfoInputAlert(title: String? = nil, message: String? = nil, completion: @escaping (_ username: String?, _ password: String?)->Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "确定", style: .default) { _ in
            let username = alertController.textFields?.first?.text
            let password = alertController.textFields?.last?.text
            completion(username, password)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        alertController.addTextField { textField in
            textField.placeholder = "username"
        }
        alertController.addTextField { textField in
            textField.placeholder = "password"
            textField.isSecureTextEntry = true
        }
        AppRouter.shared.present(alertController)
    }

}
