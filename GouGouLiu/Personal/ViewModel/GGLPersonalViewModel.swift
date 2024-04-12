//
//  GGLPersonalViewModel.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/12.
//

import SwiftUI
import RxSwift

final class GGLPersonalViewModel: ObservableObject {
    @Published var current: GGLUserModel?
    let settingRows: [SettingRow] = [.myOrders, .logout, .debug]
    private let disposeBag = DisposeBag()

    init() {
        GGLUser.userStatusSubject.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            self?.current = GGLUser.current
        }).disposed(by: disposeBag)
    }

    func pickAvatar() {
        guard let userId = GGLUser.getUserId() else { return }
        GGLUploadPhotoManager.shared.pickImage { image in
            guard let data = image?.fixOrientation().jpegData(compressionQuality: 1) else { return }
            let _ = GGLUploadPhotoManager.shared.uploadPhoto(data: data, type: .avatar, contactId: userId, progressBlock: { progress in
                ProgressHUD.showServerProgress(progress: progress.progress)
            }).observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] model in
                if let self,
                   model.code == .success,
                   let newValue = current?.copy() as? GGLUserModel {
                    newValue.avatarUrl = model.data?.previewUrl
                    GGLDataBase.shared.saveOrUpdateUser(newValue)
                    current = newValue
                }
                ProgressHUD.showServerMsg(model: model)
            })
        }
    }
}

extension GGLPersonalViewModel {

    enum SettingRow: Identifiable {
        case debug
        case logout
        case myOrders

        var id: UUID {
            return UUID()
        }
        var iconName: String {
            switch self {
            case .debug:
                return "ladybug"
            case .logout:
                return "door.right.hand.open"
            case .myOrders:
                return "paperplane"
            }
        }
        var title: String {
            switch self {
            case .debug:
                return "Debug"
            case .logout:
                return "Log out"
            case .myOrders:
                return "My Orders"
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
            case .debug:
                AppRouter.shared.push(GGLDebugViewController())
            case .logout:
                UIAlertController.popupConfirmAlert(title: "Confirm to log out?") {
                    GGLUser.logout()
                }
            case .myOrders:
                break
            }
        }
    }

}
