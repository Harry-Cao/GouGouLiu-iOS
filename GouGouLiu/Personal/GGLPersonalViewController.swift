//
//  GGLPersonalViewController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/6.
//

import SwiftUI

final class GGLPersonalViewController: GGLBaseHostingController<PersonalContentView> {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = .Personal
        setupUI()
    }

    private func setupUI() {
        
    }

}

struct PersonalContentView: View {
    var body: some View {
        List() {
            Button {
                AppRouter.shared.push(GGLDebugViewController(rootView: DebugContentView()))
            } label: {
                Text("Debug")
            }
        }
        .listStyle(.plain)
    }
}
