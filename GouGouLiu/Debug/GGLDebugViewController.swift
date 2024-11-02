//
//  GGLDebugViewController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/17/23.
//

import UIKit
import SwiftUI
import Combine

final class GGLDebugViewController: GGLBaseHostingController<DebugContentView> {
    private var cancellables = Set<AnyCancellable>()

    init() {
        super.init(rootView: DebugContentView())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = .Debug
        GGLUser.userStatusSubject.sink { [weak self] status in
            self?.rootView = DebugContentView()
        }.store(in: &cancellables)
    }
}

struct DebugContentView: View {
    let menuRows = (GGLUser.current?.is_superuser ?? false) ? DebugRow.allCases : DebugRow.allCases.filter({ !$0.needSuperuserAccess })

    var body: some View {
        List(menuRows) { row in
            Button {
                row.action()
            } label: {
                HStack {
                    Text(row.title)
                    Spacer()
                    Text(row.description)
                }
            }
        }
        .listStyle(.plain)
    }
}

extension DebugContentView {

    enum DebugRow: Identifiable, CaseIterable {
        case switchHost
        case signup
        case login
        case logout
        case signout
        case uploadAvatar
        case allUserList
        case clearImageCache
        case clearAllUser
        case clearAllPost
        case clearAllPhoto

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
            case .clearImageCache:
                return "Clear Image Cache"
            case .allUserList:
                return "All User List"
            case .switchHost:
                return "Switch Host"
            }
        }
        var description: String {
            switch self {
            case .switchHost:
                return UserDefaults.host.rawValue
            default:
                return ""
            }
        }
        var needSuperuserAccess: Bool {
            switch self {
            case .switchHost,
                    .signup,
                    .login,
                    .logout,
                    .signout,
                    .uploadAvatar,
                    .allUserList,
                    .clearImageCache:
                return false
            case .clearAllUser,
                    .clearAllPost,
                    .clearAllPhoto:
                return true
            }
        }

        func action() {
            switch self {
            case .uploadAvatar:
                guard let userId = GGLUser.getUserId() else { return }
                GGLUploadPhotoManager.shared.pickImage { image in
                    guard let data = image?.fixOrientation().jpegData(compressionQuality: 1) else { return }
                    GGLUploadPhotoManager.shared.uploadPhoto(data: data, type: .avatar, contactId: userId) { progress in
                        ProgressHUD.showServerProgress(progress: progress)
                    } completion: { model in
                        if model.code == .success {
                            UIPasteboard.general.string = model.data?.originalUrl
                        }
                        ProgressHUD.showServerMsg(model: model)
                    }
                }
            case .clearAllPhoto:
                GGLUploadPhotoManager.shared.clearAllPhotos()
            case .signup:
                UIAlertController.popupAccountInfoInputAlert(title: "注册账号") { username, password, isSuper in
                    guard let username = username,
                          let password = password else { return }
                    GGLUser.signup(username: username, password: password, isSuper: isSuper ?? false)
                }
            case .login:
                AppRouter.shared.present(GGLLoginViewController())
            case .logout:
                GGLUser.logout()
            case .signout:
                break
            case .clearAllUser:
                GGLUser.clearAll()
            case .clearAllPost:
                guard let userId = GGLUser.getUserId() else { return }
                GGLDebugNetworkHelper.shared.clearAllPost(userId: userId) { model in
                    ProgressHUD.showServerMsg(model: model)
                }
            case .clearImageCache:
                ProgressHUD.show()
                SDImageCache.shared.clearMemory()
                SDImageCache.shared.clearDisk {
                    ProgressHUD.showSucceed("清理完成")
                }
            case .allUserList:
                AppRouter.shared.push(GGLUserListViewController())
            case .switchHost:
                UserDefaults.host = GGLTool.toggleEnumCase(UserDefaults.host)
                ProgressHUD.showSucceed("Host switch to: \(UserDefaults.host.rawValue)")
            }
        }
    }

}
