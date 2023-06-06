//
//  GGLBaseViewController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/6.
//

import UIKit

class GGLBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

}
