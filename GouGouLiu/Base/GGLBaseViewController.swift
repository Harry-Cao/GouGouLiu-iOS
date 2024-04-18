//
//  GGLBaseViewController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/6.
//

import UIKit
import Hero

class GGLBaseViewController: UIViewController, GGLHeroTransitionHelperDelegate {

    private lazy var emptyDataView = GGLEmptyDataView()
    private(set) var transitionHelper = GGLHeroTransitionHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseUI()
    }

    private func setupBaseUI() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        view.backgroundColor = .systemBackground
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if transitionHelper.delegate == nil {
            transitionHelper.delegate = self
        }
    }

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        viewControllerToPresent.setHeroModalAnimationType(transitionHelperPresentAnimationType())
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        self.navigationController?.setHeroModalAnimationType(transitionHelperDismissAnimationType())
        super.dismiss(animated: flag, completion: completion)
    }

    func transitionHelperPresentViewController() -> UIViewController? { nil }
    func transitionHelperDismissAnimationType() -> HeroDefaultAnimationType { .pull(direction: .right) }
    func transitionHelperPresentAnimationType() -> HeroDefaultAnimationType { .push(direction: .left) }

}

// MARK: - Empty Data View
extension GGLBaseViewController {

    func showEmptyDataView(target: GGLEmptyDataViewDelegate) {
        emptyDataView.delegate = target
        view.addSubview(emptyDataView)
        emptyDataView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func dismissEmptyDataView() {
        emptyDataView.delegate = nil
        emptyDataView.removeFromSuperview()
    }

}
