//
//  GGLPersonalDetailViewController.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/15.
//

import SwiftUI
import Hero

final class GGLPersonalDetailViewController: GGLBaseHostingController<PersonalDetailContentView> {
    private lazy var transitionHelper = GGLTopicTransitionHelper()

    init() {
        super.init(rootView: PersonalDetailContentView())
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

// MARK: - GGLTopicTransitionHelperDelegate
extension GGLPersonalDetailViewController: GGLTopicTransitionHelperDelegate {}

struct PersonalDetailContentView: View {
    var body: some View {
        VStack {
            
        }
    }
}
