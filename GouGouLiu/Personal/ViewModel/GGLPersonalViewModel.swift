//
//  GGLPersonalViewModel.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/12.
//

import SwiftUI
import Combine

final class GGLPersonalViewModel: ObservableObject {
    @Published private(set) var current: GGLUserModel?
    let settingRows: [SettingRow] = [.myPets, .myPosts, .myOrders, .clearImageCache, .logout]
    private var cancellables = Set<AnyCancellable>()

    init() {
        GGLUser.userStatusSubject.sink { [weak self] _ in
            self?.current = GGLUser.current
        }.store(in: &cancellables)
    }

    func pickAvatar() {
        guard let userId = GGLUser.getUserId() else { return }
        GGLUploadPhotoManager.shared.pickImage { image in
            guard let data = image?.fixOrientation().jpegData(compressionQuality: 1) else { return }
            GGLUploadPhotoManager.shared.uploadPhoto(data: data, type: .avatar, contactId: userId) { progress in
                ProgressHUD.showServerProgress(progress: progress)
            } completion: { [weak self] model in
                if let self,
                   model.code == .success,
                   let newValue = current?.copy() as? GGLUserModel {
                    newValue.avatarUrl = model.data?.previewUrl
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
            }
        }
        var foregroundColor: Color {
            switch self {
            case .logout:
                Color.red
            default:
                Color(uiColor: .label)
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
            }
        }
    }

}
