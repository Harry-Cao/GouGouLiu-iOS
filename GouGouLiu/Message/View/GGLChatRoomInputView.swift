//
//  GGLChatRoomInputView.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2/27/24.
//

import SwiftUI

struct GGLChatRoomInputView: View {
    @Binding var inputText: String
    let inputMode: GGLChatInputMode
    let sendDisabled: Bool
    let onSwitchInputModel: () -> Void
    let onSendPhoto: () -> Void
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
            .foregroundStyle(Color(uiColor: .label))
            .padding([.leading, .top, .bottom])
            .padding(.trailing, 4)
            Button {
                onSendPhoto()
            } label: {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .imageScale(.large)
            }
            .foregroundStyle(Color(uiColor: .label))
            .padding(.trailing, 4)
            switch inputMode {
            case .text:
                TextEditor(text: $inputText)
                    .disableAutocorrection(true)
                    .disabled(sendDisabled)
                    .foregroundStyle(Color(uiColor: .label))
                    .cornerRadius(18)
                    .frame(height: 36)
                Button {
                    onClickSend()
                } label: {
                    Image(systemName: isSendDisabled ? "paperplane" : "paperplane.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .imageScale(.large)
                }
                .foregroundStyle(Color(uiColor: .label))
                .disabled(isSendDisabled)
                .padding([.top, .bottom, .trailing])
            case .speech:
                HStack {
                    Spacer()
                    Text("按住说话")
                        .foregroundStyle(Color(uiColor: .label))
                    Spacer()
                }
                .padding()
                .onLongPressGesture(minimumDuration: 1, maximumDistance: 60) {
                    ProgressHUD.showSucceed("开始录音...")
                } onPressingChanged: { onPress in
                    print("!!!onPress: \(onPress)")
                }
            }
        }
        .background(Color.gray.opacity(0.1))
    }
}
