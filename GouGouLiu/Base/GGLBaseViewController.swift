//
//  GGLBaseViewController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/6.
//

import UIKit

class GGLBaseViewController: UIViewController, UIGestureRecognizerDelegate {

    private lazy var emptyDataView = GGLEmptyDataView()

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
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

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
