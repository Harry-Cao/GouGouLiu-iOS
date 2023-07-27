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
        .uploadAvatar,
        .clearAllPhoto,
        .signup,
        .login,
        .logout,
        .signout,
        .clearAllUser,
        .clearAllPost, 
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
        case uploadAvatar
        case clearAllPhoto
        case signup
        case login
        case logout
        case signout
        case clearAllUser
        case clearAllPost

        var id: UUID {
            return UUID()
        }
        var title: String {
            switch self {
            case .uploadAvatar:
                return "Upload Avatar"
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
            case .clearAllPost:
                return "Clear All Posts"
            }
        }

        func action() {
            switch self {
            case .uploadAvatar:
                guard let userId = GGLUser.getUserId() else { return }
                GGLUploadPhotoManager.shared.pickImage { image in
                    guard let data = image?.jpegData(compressionQuality: 1) else { return }
                    GGLUploadPhotoManager.shared.uploadPhoto(data: data, type: .avatar, contactId: userId, progressBlock: { progress in
                        ProgressHUD.showProgress(progress.progress)
                    }).subscribe(onNext: { model in
                        if model.code == .success {
                            UIPasteboard.general.string = model.data?.url
                        }
                        ProgressHUD.showServerMsg(model: model)
                    }).disposed(by: GGLUploadPhotoManager.shared.disposeBag)
                }
            case .clearAllPhoto:
                GGLUploadPhotoManager.shared.clearAllPhotos()
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
            case .clearAllPost:
                break
            }
        }
    }

}
