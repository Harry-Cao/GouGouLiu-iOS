//
//  GGLEditPetViewController.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/9/2.
//

import SwiftUI
import SDWebImageSwiftUI

final class GGLEditPetViewController: GGLBaseHostingController<EditPetContentView> {
    private let viewModel: GGLEditPetViewModel

    init(pet: GGLPetModel? = nil) {
        viewModel = GGLEditPetViewModel(pet: pet)
        super.init(rootView: EditPetContentView(viewModel: viewModel))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = viewModel.pageMode.navigationTitle
    }
}

struct EditPetContentView: View {
    @ObservedObject var viewModel: GGLEditPetViewModel

    var body: some View {
        VStack {
            ScrollView {
                UpdatePetPhotoView(avatarUrl: viewModel.avatarUrl) {
                    viewModel.pickPetPhoto()
                }
                PetDetailsContainer {
                    PetTypeInputView(petType: $viewModel.petType)
                    PetNameInputView(name: $viewModel.name)
                    PetWeightInputView(weight: $viewModel.weight)
                    PetAgeInputView(age: $viewModel.age)
                    PetSexInputView(sex: $viewModel.sex)
                    PetBreedsInputView(breeds: $viewModel.breeds) {
                        AppRouter.shared.push(GGLSelectBreedsViewController(viewModel: viewModel))
                    }
                }
                if viewModel.pageMode == .update {
                    Button("Delete this profile") {
                        UIAlertController.popupConfirmAlert(title: "Are you sure to delete this profile?") {
                            viewModel.deletePet()
                        }
                    }
                    .foregroundStyle(Color(.red))
                }
            }
            HStack {
                Button(action: {
                    viewModel.updatePet()
                }, label: {
                    Spacer()
                    Text("Save")
                    Spacer()
                })
                .disabled(viewModel.saveDisabled)
                .padding()
                .foregroundStyle(Color(.label))
                .background {
                    RoundedRectangle(cornerRadius: 12, style: .circular)
                        .foregroundStyle(Color(viewModel.saveDisabled ? .lightGray : .theme_color))
                }
            }
            .padding()
        }
        .background(Color(.secondarySystemBackground))
    }

    struct PetDetailsContainer<Content: View>: View {
        @ViewBuilder let children: () -> Content

        var body: some View {
            VStack {
                HStack(spacing: 12, content: {
                    Image(systemName: "pawprint")
                        .resizable()
                        .frame(width: 28, height: 24)
                    Text("Pet details")
                        .font(.title)
                        .fontWeight(.medium)
                    Spacer()
                })
                .padding(EdgeInsets(top: 20, leading: .zero, bottom: 12, trailing: 20))
                HStack {
                    Text("Provide your sitter with a description of your pet")
                        .font(.caption)
                        .foregroundStyle(Color(.gray))
                    Spacer()
                }
                .padding(EdgeInsets(top: .zero, leading: .zero, bottom: 8, trailing: .zero))
                VStack(spacing: 20) {
                    children()
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 12, style: .circular)
                        .foregroundStyle(Color(.systemBackground))
                }
            }
            .padding()
        }
    }
}
