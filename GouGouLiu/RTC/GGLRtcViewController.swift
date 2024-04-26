//
//  GGLRtcViewController.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/21.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI
import RxSwift

final class GGLRtcViewController: GGLBaseHostingController<GGLRtcContentView> {
    private let disposeBag = DisposeBag()

    init(role: GGLRtcViewModel.Role, type: GGLWSRtcMessageModel.RtcType, channelId: String, targetId: String) {
        super.init(rootView: GGLRtcContentView(viewModel: GGLRtcViewModel.shared))
        GGLRtcViewModel.shared.setup(role: role, type: type, channelId: channelId, targetId: targetId, delegate: self)
        self.modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - GGLRtcViewModelDelegate
extension GGLRtcViewController: GGLRtcViewModelDelegate {
    func needDismiss() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.dismiss(animated: true)
        }
    }

    func getDisposeBag() -> DisposeBag { disposeBag }
}

struct GGLRtcContentView: View {
    @ObservedObject var viewModel: GGLRtcViewModel

    var body: some View {
        ZStack {
            Image("blur_glass_background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            WebImage(url: URL(string: viewModel.targetUser?.avatarUrl ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120, alignment: .center)
                .clipShape(.circle)
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
            VStack {
                Spacer()
                switch viewModel.role {
                case .sender:
                    ActionButton(type: .cancel) {
                        viewModel.onClickCancelButton()
                    }
                case .receiver:
                    switch viewModel.stage {
                    case .holding:
                        HStack {
                            ActionButton(type: .cancel) {
                                viewModel.onClickCancelButton()
                            }
                            ActionButton(type: .confirm) {
                                viewModel.onClickConfirmButton()
                            }
                        }
                    case .talking, .free:
                        ActionButton(type: .cancel) {
                            viewModel.onClickCancelButton()
                        }
                    }
                }
            }
        }
        .onAppear(perform: {
            viewModel.onAppear()
        })
    }
}

extension GGLRtcContentView {
    struct ActionButton: View {
        let type: ActionType
        let action: (() -> Void)?

        var body: some View {
            Button(action: {
                action?()
            }, label: {
                Image(systemName: type.systemImage)
                    .frame(width: 84, height: 84, alignment: .center)
                    .background(type.backgroundColor)
                    .clipShape(.circle)
            })
            .foregroundColor(.white)
            .padding()
        }

        enum ActionType {
            case confirm
            case cancel

            var systemImage: String {
                switch self {
                case .confirm:
                    return "phone.fill"
                case .cancel:
                    return "phone.down.fill"
                }
            }
            var backgroundColor: Color {
                switch self {
                case .confirm:
                    return .green
                case .cancel:
                    return .red
                }
            }
        }
    }
}
