//
//  GGLChatRoomInputView.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2/27/24.
//

import SwiftUI
import ProgressHUD

struct GGLChatRoomInputView: View {
    @Binding var inputText: String
    let inputMode: GGLChatInputMode
    let sendDisabled: Bool
    let onSwitchInputModel: () -> Void
    let onClickSend: () -> Void

    private var isSendDisabled: Bool {
        if sendDisabled {
            return true
        } else if inputText.isEmpty {
            return true
        }
        return false
    }

    private var inputModeImageSystemName: String {
        switch inputMode {
        case .text:
            return "wave.3.left.circle"
        case .speech:
            return "keyboard"
        }
    }

    var body: some View {
        HStack {
            Button {
                onSwitchInputModel()
            } label: {
                Image(systemName: inputModeImageSystemName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .imageScale(.large)
            }
            .foregroundColor(Color(uiColor: .label))
            switch inputMode {
            case .text:
                TextField(sendDisabled ? "" : "输入问题...", text: $inputText)
                    .disableAutocorrection(true)
                    .padding([.leading, .trailing], 8)
                    .disabled(sendDisabled)
                    .foregroundColor(Color(uiColor: .label))
                    .onSubmit {
                        onClickSend()
                    }
                Button {
                    onClickSend()
                } label: {
                    Image(systemName: isSendDisabled ? "paperplane" : "paperplane.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .imageScale(.large)
                }
                .foregroundColor(Color(uiColor: .label))
                .disabled(isSendDisabled)
            case .speech:
                HStack {
                    Spacer()
                    Text("按住说话")
                        .foregroundColor(Color(uiColor: .label))
                    Spacer()
                }
                .onLongPressGesture(minimumDuration: 1, maximumDistance: 60) {
                    ProgressHUD.show("开始录音...")
                } onPressingChanged: { onPress in
                    print("!!!onPress: \(onPress)")
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
    }
}
