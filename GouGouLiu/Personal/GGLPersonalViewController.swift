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
        .login,
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
        case login
        case debug

        var id: UUID {
            return UUID()
        }
        var title: String {
            switch self {
            case .login:
                return "Login"
            case .debug:
                return "Debug"
            }
        }

        func action() {
            switch self {
            case .login:
                GGLUser.current.login()
            case .debug:
                AppRouter.shared.push(GGLDebugViewController(rootView: DebugContentView()))
            }
        }
    }

}
