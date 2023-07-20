//
//  GGLPersonalViewController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/6.
//

import SwiftUI

final class GGLPersonalViewController: GGLBaseHostingController<PersonalContentView> {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = .Personal
    }

}

struct PersonalContentView: View {
    var settingRows: [SettingRow] = [
        .signup,
        .login,
        .logout,
        .signout,
        .debug,
    ]
    var body: some View {
        List(settingRows) { row in
            Button {
                row.action()
            } label: {
                Text(row.title)
            }
        }
        .listStyle(.plain)
    }
}

extension PersonalContentView {

    enum SettingRow: Identifiable {
        case signup
        case login
        case logout
        case signout
        case debug

        var id: UUID {
            return UUID()
        }
        var title: String {
            switch self {
            case .signup:
                return "Sign up"
            case .login:
                return "Log in"
            case .logout:
                return "Log out"
            case .signout:
                return "Sign out"
            case .debug:
                return "Debug"
            }
        }

        func action() {
            switch self {
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
            case .debug:
                AppRouter.shared.push(GGLDebugViewController(rootView: DebugContentView()))
            }
        }
    }

}
