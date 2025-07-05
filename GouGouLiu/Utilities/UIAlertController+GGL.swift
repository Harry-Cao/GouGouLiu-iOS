//
//  UIAlertController+GGL.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/21/23.
//

import Foundation

extension UIAlertController {

    static func popupAccountInfoInputAlert(title: String? = nil, message: String? = nil, completion: @escaping (_ username: String?, _ password: String?, _ isSuper: Bool?)->Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { _ in
            let username = alertController.textFields?.first?.text
            let password = alertController.textFields?[safe: 1]?.text
            let isSuper = alertController.textFields?[safe: 2]?.text == "t"
            completion(username, password, isSuper)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        alertController.addTextField { textField in
            textField.placeholder = "username"
            textField.snp.makeConstraints { make in
                make.height.equalTo(24)
            }
        }
        alertController.addTextField { textField in
            textField.placeholder = "password"
            textField.isSecureTextEntry = true
            textField.snp.makeConstraints { make in
                make.height.equalTo(24)
            }
        }
        alertController.addTextField { textField in
            textField.placeholder = "(optional)isSuper? (t/f)"
            textField.snp.makeConstraints { make in
                make.height.equalTo(24)
            }
        }
        AppRouter.shared.present(alertController)
    }

    static func popupConfirmAlert(title: String? = nil, completion: (()->Void)? = nil) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { _ in
            completion?()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        [confirmAction, cancelAction].forEach(alertController.addAction)
        AppRouter.shared.present(alertController)
    }

}
