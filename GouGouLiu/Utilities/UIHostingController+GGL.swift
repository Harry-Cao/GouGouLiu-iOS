//
//  UIHostingController+GGL.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/18.
//

import Foundation
import SwiftUI

extension UIHostingController {

    func setupBackBarButtonItem() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        view.backgroundColor = .systemBackground
    }

}
