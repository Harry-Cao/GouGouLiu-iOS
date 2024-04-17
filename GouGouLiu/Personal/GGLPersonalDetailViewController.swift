//
//  GGLPersonalDetailViewController.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/15.
//

import SwiftUI
import Hero
import SDWebImageSwiftUI

final class GGLPersonalDetailViewController: GGLBaseHostingController<PersonalDetailContentView> {
    private lazy var transitionHelper = GGLHeroTransitionHelper()

    init(user: GGLUserModel) {
        super.init(rootView: PersonalDetailContentView(user: user))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTransition()
    }

    private func setupNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: .navigation_bar_back, style: .plain, target: self, action: #selector(didTapBackButton))
    }

    private func setupTransition() {
        self.navigationController?.heroModalAnimationType = .pull(direction: .right)
        transitionHelper.delegate = self
    }

    @objc private func didTapBackButton() {
        self.dismiss(animated: true)
    }
}

// MARK: - GGLHeroTransitionHelperDelegate
extension GGLPersonalDetailViewController: GGLHeroTransitionHelperDelegate {}

struct PersonalDetailContentView: View {
    let user: GGLUserModel

    var body: some View {
        VStack {
            WebImage(url: URL(string: user.avatarUrl ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120, alignment: .center)
                .clipShape(.circle)
            Text(user.userName ?? "")
                .font(Font.system(size: 24, weight: .bold))
                .padding(.bottom, 24)
            Button {
                AppRouter.shared.chat(user: user)
            } label: {
                Image(systemName: "message")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48, alignment: .center)
            }
        }
    }
}
