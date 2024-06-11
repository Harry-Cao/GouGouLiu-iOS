//
//  GGLDogWalkingViewController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/7/5.
//

import SwiftUI

final class GGLDogWalkingViewController: GGLBaseHostingController<DogWalkingContentView> {

    init() {
        super.init(rootView: DogWalkingContentView())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Dog Walking"
    }

}

struct DogWalkingContentView: View {
    var body: some View {
        EmptyView()
    }
}
