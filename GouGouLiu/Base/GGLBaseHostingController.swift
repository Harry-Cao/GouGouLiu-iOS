//
//  GGLBaseHostingController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/18/23.
//

import SwiftUI

class GGLBaseHostingController<Content>: UIHostingController<Content> where Content: View {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseUI()
    }

    private func setupBaseUI() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        view.backgroundColor = .systemBackground
    }

}
