//
//  GGLServicesViewController.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/5/16.
//

import SwiftUI

final class GGLServicesViewController: GGLBaseHostingController<ServiceContentView> {

    init() {
        super.init(rootView: ServiceContentView())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

struct ServiceContentView: View {
    let dataSource = ServiceType.allCases

    var body: some View {
        ScrollView {
            HStack {
                Text("Select a Service")
                    .font(Font.system(size: 36, weight: .semibold))
                Spacer()
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
            ForEach(dataSource) { item in
                GGLServiceCell(item: item)
            }
        }
    }
}

extension ServiceContentView {
    enum ServiceType: CaseIterable, Identifiable {
        case dogWalking
        case training

        var id: UUID { UUID() }

        var iconName: String {
            switch self {
            case .dogWalking:
                return "pawprint"
            case .training:
                return "dog"
            }
        }

        var title: String {
            switch self {
            case .dogWalking:
                return "Dog Walking"
            case .training:
                return "Training (coming soon~)"
            }
        }

        var description: String {
            switch self {
            case .dogWalking:
                return "in your neighborhood"
            case .training:
                return "video sessions"
            }
        }

        func action() {
            switch self {
            case .dogWalking:
                break
            case .training:
                break
            }
        }
    }
}
