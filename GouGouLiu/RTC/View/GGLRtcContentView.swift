//
//  GGLRtcContentView.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/27.
//

import SwiftUI
import SDWebImageSwiftUI

struct GGLRtcContentView: View {
    @ObservedObject var viewModel: GGLRtcViewModel

    var body: some View {
        ZStack {
            switch viewModel.type {
            case .voice:
                PlaceholderView(user: viewModel.targetUser)
            case .video:
                if viewModel.stage == .talking {
                    UIViewBridge(view: viewModel.remoteView)
                        .ignoresSafeArea()
                } else {
                    PlaceholderView(user: viewModel.targetUser)
                }
                VStack {
                    HStack {
                        Spacer()
                        UIViewBridge(view: viewModel.localView)
                            .frame(width: mainWindow.bounds.width/3, height: mainWindow.bounds.height/3)
                    }
                    Spacer()
                }
            }

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
            .padding(.bottom)
        }
        .onAppear(perform: {
            viewModel.onAppear()
        })
        .onDisappear(perform: {
            viewModel.onDisappear()
        })
    }
}

// MARK: - ActionButton
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
            .foregroundStyle(.white)
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

// MARK: - PlaceholderView
extension GGLRtcContentView {
    struct PlaceholderView: View {
        let user: GGLUserModel?

        var body: some View {
            GeometryReader(content: { geometry in
                Image(.blurGlassBackground)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
            })
            .ignoresSafeArea()
            WebImage(url: URL(string: user?.avatar?.previewUrl ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120, alignment: .center)
                .clipShape(.circle)
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
        }
    }
}

struct UIViewBridge: UIViewRepresentable {
    let view: UIView
    func makeUIView(context: Context) -> some UIView { view }
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
