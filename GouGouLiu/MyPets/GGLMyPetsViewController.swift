//
//  GGLMyPetsViewController.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/9/1.
//

import UIKit
import SwiftUI

final class GGLMyPetsViewController: GGLBaseHostingController<MyPetsContentView> {
    private let viewModel: GGLMyPetsViewModel

    init() {
        viewModel = GGLMyPetsViewModel()
        super.init(rootView: MyPetsContentView(viewModel: viewModel))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "My Pets"
    }
}

struct MyPetsContentView: View {
    @ObservedObject var viewModel: GGLMyPetsViewModel
    var body: some View {
        LazyVStack {
            ForEach(viewModel.myPets, id: \.id) { pet in
                Text(pet.name ?? "")
            }
        }
        .onAppear(perform: {
            viewModel.requestData()
        })
    }
}
