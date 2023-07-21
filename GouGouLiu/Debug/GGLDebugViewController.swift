//
//  GGLDebugViewController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/17/23.
//

import UIKit
import SwiftUI
import RxSwift
import ProgressHUD

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
            }
        }

        func action() {
            switch self {
            case .uploadPhoto:
                GGLServerPhotoManager.shared.pickImage { image in
                    guard let data = image?.jpegData(compressionQuality: 1) else { return }
                    GGLServerPhotoManager.shared.uploadPhoto(data: data, type: .avatar, contactId: "3260").subscribe(onNext: { response in
                        if response.code == 0 {
                            ProgressHUD.show(response.data?.url, icon: .succeed)
                            UIPasteboard.general.string = response.data?.url
                        }
                    }).disposed(by: GGLServerPhotoManager.shared.disposeBag)
                }
            case .clearAllPhoto:
                GGLServerPhotoManager.shared.clearAllPhotos().subscribe(onNext: { response in
                    if response.code == 0 {
                        ProgressHUD.showSucceed()
                    }
                }).disposed(by: GGLServerPhotoManager.shared.disposeBag)
            case .signup:
                UIAlertController.popupAccountInfoInputAlert(title: "注册账号") { username, password in
                    guard let username = username,
                          let password = password else { return }
                    GGLUser.current.signup(username: username, password: password)
                }
            case .login:
                UIAlertController.popupAccountInfoInputAlert(title: "登录账号") { username, password in
                    guard let username = username,
                          let password = password else { return }
                    GGLUser.current.login(username: username, password: password)
                }
            case .logout:
                GGLUser.current.logout()
            case .signout:
                break
            }
        }
    }

}
