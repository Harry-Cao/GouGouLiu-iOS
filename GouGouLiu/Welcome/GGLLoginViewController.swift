//
//  GGLLoginViewController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 3/13/24.
//

import SwiftUI
import Combine

final class GGLLoginViewController: GGLBaseHostingController<LoginContentView> {
    private var cancellables = Set<AnyCancellable>()

    init() {
        super.init(rootView: LoginContentView())
        onLoginSuccess()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func onLoginSuccess() {
        GGLUser.userStatusSubject.sink { [weak self] status in
            switch status {
            case .login:
                self?.dismiss(animated: true)
            default:
                break
            }
        }.store(in: &cancellables)
    }
}

struct LoginContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""

    private var loginDisabled: Bool {
        return username.isEmpty || password.isEmpty
    }

    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .disableAutocorrection(true)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5.0)
                .padding(.bottom, 20)

            SecureField("Password", text: $password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5.0)
                .padding(.bottom, 20)

            Button(action: {
                GGLUser.login(username: self.username, password: self.password)
            }) {
                Text("Login")
                    .foregroundStyle(.white)
                    .padding()
                    .frame(width: 200, height: 50)
                    .background(Color(loginDisabled ? .lightGray : .theme_color))
                    .cornerRadius(10.0)
            }
            .disabled(loginDisabled)
            .padding(.bottom, 20)

            Button(action: {
                GGLUser.signup(username: self.username, password: self.password)
            }) {
                Text("Sign Up")
                    .foregroundStyle(.white)
                    .padding()
                    .frame(width: 200, height: 50)
                    .background(Color(loginDisabled ? .lightGray : .theme_color))
                    .cornerRadius(10.0)
            }
            .disabled(loginDisabled)
        }
        .padding()
    }
}
