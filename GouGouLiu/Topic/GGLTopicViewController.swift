//
//  GGLTopicViewController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/6.
//

import UIKit

final class GGLTopicViewController: GGLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = .Topic
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true)
    }

}
