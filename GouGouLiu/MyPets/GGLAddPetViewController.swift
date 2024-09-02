//
//  GGLAddPetViewController.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/9/2.
//

import SwiftUI

final class GGLAddPetViewController: GGLBaseHostingController<AddPetContentView> {
    init() {
        super.init(rootView: AddPetContentView())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add Pet"
    }
}

struct AddPetContentView: View {
    var body: some View {
        VStack {
            
        }
    }
}
