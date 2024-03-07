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

    static let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = .Debug
    }

}

struct DebugContentView: View {
    var menuRows: [DebugRow] = [
        .uploadAvatar,
        .signup,
        .login,
        .logout,
        .signout,
        .clearAllUser,
        .clearAllPost,
        .clearAllPhoto,
        .clearImageCache,
        .addMessage
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
        case clearImageCache
        case addMessage

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
            case .addMessage:
                return "Add Message"
            }
        }

        func action() {
            switch self {
            case .uploadAvatar:
                guard let userId = GGLUser.getUserId() else { return }
                GGLUploadPhotoManager.shared.pickImage { image in
                    guard let data = image?.fixOrientation().jpegData(compressionQuality: 1) else { return }
                    GGLUploadPhotoManager.shared.uploadPhoto(data: data, type: .avatar, contactId: userId, progressBlock: { progress in
                        ProgressHUD.showServerProgress(progress: progress.progress)
                    }).subscribe(onNext: { model in
                        if model.code == .success {
                            UIPasteboard.general.string = model.data?.originalUrl
                        }
                        ProgressHUD.showServerMsg(model: model)
                    }, onError: { error in
                        ProgressHUD.showFailed(error.localizedDescription)
                    }).disposed(by: GGLUploadPhotoManager.shared.disposeBag)
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
                UIAlertController.popupAccountInfoInputAlert(title: "登录账号") { username, password, _ in
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
                guard let userId = GGLUser.getUserId() else { return }
                let postViewModel = GGLPostViewModel()
                postViewModel.clearAllPost(userId: userId).subscribe(onNext: { model in
                    ProgressHUD.showServerMsg(model: model)
                }).disposed(by: GGLDebugViewController.disposeBag)
            case .clearImageCache:
                ProgressHUD.show()
                SDImageCache.shared.clearMemory()
                SDImageCache.shared.clearDisk {
                    ProgressHUD.showSucceed("清理完成")
                }
            case .addMessage:
                let clientObject = GGLMessageModel()
                clientObject.avatar = "http://f3.ttkt.cc:12873/GGLServer/media/global/dog.png"
                clientObject.name = "狗狗溜客服"
                GGLDataBase.shared.add(clientObject)
                GGLDataBase.shared.insert(GGLChatModel.createText(role: .other, content: "您在使用过程中遇到任何问题都可以向我反馈", avatar: clientObject.avatar), to: clientObject.messages)
            }
        }
    }

}
