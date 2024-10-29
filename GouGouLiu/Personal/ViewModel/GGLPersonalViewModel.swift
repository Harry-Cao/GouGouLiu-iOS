//
//  GGLPersonalViewModel.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/12.
//

import UIKit
import Combine

final class GGLPersonalViewModel: ObservableObject {
    @Published private(set) var current: GGLUserModel?
    @Published private(set) var settingRows: [SettingRow] = [.login]
    private var cancellables = Set<AnyCancellable>()

    init() {
        GGLUser.userStatusSubject.sink { [weak self] _ in
            guard let self else { return }
            current = GGLUser.current
            if let _ = GGLUser.current {
                settingRows = [.myPets, .myPosts, .myOrders, .clearImageCache, .logout]
            } else {
                settingRows = [.login]
            }
        }.store(in: &cancellables)
    }

    func pickAvatar() {
        guard let userId = GGLUser.getUserId(showHUD: false) else { return }
        GGLUploadPhotoManager.shared.pickImage { image in
            guard let data = image?.fixOrientation().jpegData(compressionQuality: 1) else { return }
            GGLUploadPhotoManager.shared.uploadPhoto(data: data, type: .avatar, contactId: userId) { progress in
                ProgressHUD.showServerProgress(progress: progress)
            } completion: { [weak self] model in
                if let self,
                   model.code == .success,
                   let newValue = current?.copy() as? GGLUserModel {
                    newValue.avatar = model.data
                    GGLDataBase.shared.saveOrUpdateUser(newValue)
                    current = newValue
                }
                ProgressHUD.showServerMsg(model: model)
            }
        }
    }
}

extension GGLPersonalViewModel {

    enum SettingRow: Identifiable {
        case myPets
        case myPosts
        case myOrders
        case clearImageCache
        case logout
        case login

        var id: UUID {
            return UUID()
        }
        var iconName: String {
            switch self {
            case .myPets:
                return "pawprint"
            case .myPosts:
                return "sparkles"
            case .myOrders:
                return "paperplane"
            case .clearImageCache:
                return "xmark.bin"
            case .logout:
                return "door.right.hand.open"
            case .login:
                return "rectangle.portrait.and.arrow.right"
            }
        }
        var title: String {
            switch self {case .myPets:
                return "My pets"
            case .myPosts:
                return "My posts"
            case .myOrders:
                return "My orders"
            case .clearImageCache:
                return "Clear image cache"
            case .logout:
                return "Log out"
            case .login:
                return "Log in"
            }
        }
        var foregroundColor: UIColor {
            switch self {
            case .logout:
                return .red
            default:
                return .label
            }
        }

        func action() {
            switch self {
            case .myPets:
                AppRouter.shared.push(GGLMyPetsViewController())
            case .myPosts, .myOrders:
                break
            case .clearImageCache:
                ProgressHUD.show()
                SDImageCache.shared.clearMemory()
                SDImageCache.shared.clearDisk {
                    ProgressHUD.showSucceed("Cleared")
                }
            case .logout:
                UIAlertController.popupConfirmAlert(title: "Confirm to log out?") {
                    GGLUser.logout()
                }
            case .login:
                AppRouter.shared.present(GGLLoginViewController())
            }
        }
    }

}
