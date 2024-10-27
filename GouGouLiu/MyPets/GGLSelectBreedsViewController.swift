//
//  GGLSelectBreedsViewController.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/10/26.
//

import SwiftUI

final class GGLSelectBreedsViewController: GGLBaseHostingController<GGLSelectBreedsContentView> {
    init(viewModel: GGLEditPetViewModel) {
        super.init(rootView: GGLSelectBreedsContentView(viewModel: viewModel) { breeds in
            viewModel.breeds = breeds
            AppRouter.shared.pop(animated: true)
        })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Breeds"
    }
}

struct GGLSelectBreedsContentView: View {
    let viewModel: GGLEditPetViewModel
    let onConfirm: (_ breeds: [GGLBreedModel]) -> Void
    @State var breeds = [BreedUIModel]()
    private let networkHelper = GGLPetNetworkHelper()

    private var confirmDisabled: Bool {
        return breeds.isEmpty
    }

    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(breeds, id: \.breedId) { breed in
                        Button {
                            guard let index = breeds.firstIndex(where: { breed.breedId == $0.breedId }) else { return }
                            breeds[index] = BreedUIModel(breedId: breed.breedId, breedName: breed.breedName, selected: !breed.selected)
                        } label: {
                            HStack {
                                Text(breed.breedName ?? "")
                                Spacer()
                                if breed.selected {
                                    Image(systemName: "checkmark")
                                }
                            }
                            .padding()
                        }
                        .foregroundStyle(Color(.label))
                    }
                }
            }
            HStack {
                Button(action: {
                    let selectedBreeds = breeds.compactMap({ $0.selected ? GGLBreedModel(breedId: $0.breedId, breedName: $0.breedName) : nil })
                    onConfirm(selectedBreeds)
                }, label: {
                    Spacer()
                    Text("Confirm")
                    Spacer()
                })
                .disabled(confirmDisabled)
                .padding()
                .foregroundStyle(Color(.label))
                .background {
                    RoundedRectangle(cornerRadius: 12, style: .circular)
                        .foregroundStyle(Color(confirmDisabled ? .lightGray : .theme_color))
                }
            }
            .padding()
        }
        .onAppear {
            requestBreeds()
        }
    }

    private func requestBreeds() {
        networkHelper.getBreeds(petType: viewModel.petType) { model in
            guard model.code == .success,
                  let breeds = model.data else { return }
            self.breeds = breeds.map({ breed in
                BreedUIModel(
                    breedId: breed.breedId,
                    breedName: breed.breedName,
                    selected: viewModel.breeds.contains(where: { selectedBreed in
                        breed.breedId == selectedBreed.breedId
                    })
                )
            })
        }
    }
}

extension GGLSelectBreedsContentView {
    struct BreedUIModel {
        let breedId: Int?
        let breedName: String?
        var selected: Bool = false
    }
}
