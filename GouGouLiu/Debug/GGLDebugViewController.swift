//
//  GGLDebugViewController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/17/23.
//

import UIKit
import SwiftUI
import RxSwift

final class GGLDebugViewController: GGLBaseHostingController<DebugContentView> {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = .Debug
    }

}

struct DebugContentView: View {
    var menuRows: [DebugRow] = [
        .uploadPhoto,
        .clearAllPhoto,
        .signup,
        .login,
        .logout,
        .signout,
        .clearAllUser,
    ]
    var body: some View {
        List(menuRows) { row in
            Button {
                row.action()
            } label: {
                Text(row.title)
            }
        }
        .listStyle(.plain)
    }
}

extension DebugContentView {

    enum DebugRow: Identifiable {
        case uploadPhoto
        case clearAllPhoto
        case signup
        case login
        case logout
        case signout
        case clearAllUser

        var id: UUID {
            return UUID()
        }
        var title: String {
            switch self {
            case .uploadPhoto:
                return "Upload Photo"
            case .clearAllPhoto:
                return "Clear All Photos"
            case .signup:
                return "Sign Up"
            case .login:
                return "Log In"
            case .logout:
                return "Log Out"
            case .signout:
                return "Sign Out"
            case .clearAllUser:
                return "Clear All Users"
            }
        }

        func action() {
            switch self {
            case .uploadPhoto:
                guard let userId = GGLUser.getUserId() else { return }
                GGLServerPhotoManager.shared.pickImage { image in
                    guard let data = image?.jpegData(compressionQuality: 1) else { return }
                    GGLServerPhotoManager.shared.uploadPhoto(data: data, type: .avatar, contactId: userId).subscribe(onNext: { model in
                        if model.code == 0 {
                            ProgressHUD.showSucceed(model.msg)
                            UIPasteboard.general.string = model.data?.url
                        }
                    }).disposed(by: GGLServerPhotoManager.shared.disposeBag)
                }
            case .clearAllPhoto:
                GGLServerPhotoManager.shared.clearAllPhotos()
            case .signup:
                UIAlertController.popupAccountInfoInputAlert(title: "注册账号") { username, password in
                    guard let username = username,
                          let password = password else { return }
                    GGLUser.signup(username: username, password: password)
                }
            case .login:
                UIAlertController.popupAccountInfoInputAlert(title: "登录账号") { username, password in
                    guard let username = username,
                          let password = password else { return }
                    GGLUser.login(username: username, password: password)
                }
            case .logout:
                GGLUser.logout()
            case .signout:
                break
            case .clearAllUser:
                GGLUser.clearAll()
            }
        }
    }

}
