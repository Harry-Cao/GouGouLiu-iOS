//
//  GGLPostViewController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/24/23.
//

import UIKit

final class GGLPostViewController: GGLBaseViewController {

    private let viewModel = GGLPostViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = .Post
    }

}
