//
//  GGLDebugViewController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/17/23.
//

import UIKit
import SwiftUI

final class GGLDebugViewController: UIHostingController<DebugContentView> {

    init() {
        super.init(rootView: DebugContentView())
    }

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = .Debug
    }

}

struct DebugContentView: View {
    var menuRows: [DebugRow] = [
        .uploadPhoto
    ]
    var body: some View {
        List(menuRows) { row in
            Button {
                row.action?()
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
                return "Update Photo"
            }
        }
        var action: (() -> Void)? {
            var action: (() -> Void)?
            switch self {
            case .uploadPhoto:
                action = {
                    print("Update Photo")
                }
            }
            return action
        }
    }

}
