//
//  GGLPersonalViewController.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/6/6.
//

import SwiftUI
import SDWebImageSwiftUI

final class GGLPersonalViewController: GGLBaseHostingController<PersonalContentView> {

    init() {
        super.init(rootView: PersonalContentView(viewModel: GGLPersonalViewModel()))
    }

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

struct PersonalContentView: View {
    @ObservedObject var viewModel: GGLPersonalViewModel

    var body: some View {
        VStack {
            if let current = viewModel.current {
                Header(user: current) {
                    viewModel.pickAvatar()
                }
                List(viewModel.settingRows) { row in
                    Button {
                        row.action()
                    } label: {
                        HStack {
                            Image(systemName: row.iconName)
                                .frame(width: 20, height: 20, alignment: .center)
                                .foregroundStyle(row.foregroundColor)
                            Text(row.title)
                                .font(.system(size: 16))
                                .foregroundStyle(row.foregroundColor)
                        }
                    }
                }
                .listStyle(.plain)
            } else {
                LoginContentView()
            }
        }
    }
}

extension PersonalContentView {

    struct Header: View {
        let user: GGLUserModel
        let onClickPickAvatar: () -> Void
        var body: some View {
            HStack {
                WebImage(url: URL(string: user.avatarUrl ?? ""))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 84, height: 84, alignment: .center)
                    .clipShape(.circle)
                    .padding(.trailing, 8)
                    .onTapGesture {
                        onClickPickAvatar()
                    }
                VStack(alignment: .leading, content: {
                    Text(GGLUser.current?.userName ?? "")
                        .font(Font.system(size: 24, weight: .bold))
                        .padding(.bottom, 4)
                    Text("UserId: \(GGLUser.current?.userId ?? "")")
                        .font(.caption)
                        .foregroundStyle(.gray.opacity(0.8))
                })
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding([.leading, .trailing, .bottom])
        }
    }

}
