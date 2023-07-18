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

        var id: UUID {
            return UUID()
        }
        var title: String {
            switch self {
            case .uploadPhoto:
                return "Upload Photo"
            }
        }

        func action() {
            switch self {
            case .uploadPhoto:
                let image: UIImage? = .tab_bar_home_normal
                guard let data = image?.pngData() else { return }
                GGLUploadPhotoManager.shared.uploadPhoto(data: data, type: .avatar).subscribe(onNext: { response in
                    if response.code == 0 {
                        ProgressHUD.showSucceed()
                    }
                }).disposed(by: GGLUploadPhotoManager.shared.disposeBag)
            }
        }
    }

}
