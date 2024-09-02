//
//  GGLMyPetsViewController.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/9/1.
//

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
        navigationItem.rightBarButtonItem = barButtonItem(navigationItem: .image(UIImage(systemName: "plus"), #selector(onClickAddPet)))
    }

    @objc private func onClickAddPet() {
        AppRouter.shared.push(GGLAddPetViewController())
    }
}

struct MyPetsContentView: View {
    @ObservedObject var viewModel: GGLMyPetsViewModel

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0, content: {
                ForEach(viewModel.myPets, id: \.id) { pet in
                    GGLPetCard(pet: pet)
                }
            })
        }
        .onAppear(perform: {
            viewModel.requestData()
        })
    }
}
