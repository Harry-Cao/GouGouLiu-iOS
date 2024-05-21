//
//  GGLHomeViewModel.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/7/5.
//

import UIKit
import Combine
import Moya

final class GGLHomeViewModel {

    @Published var dataSource = [GGLHomePostModel]()
    private let moyaProvider = MoyaProvider<GGLHomePostAPI>(session: GGLAlamofireSession.shared)
    private var cancellables = Set<AnyCancellable>()

    func getHomePostData() {
        moyaProvider.requestPublisher(GGLHomePostAPI())
            .map(GGLMoyaModel<[GGLHomePostModel]>.self)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                guard case let .failure(error) = completion else { return }
                print(error)
                if UserDefaults.host == .intranet {
                    UserDefaults.host = .internet
                    ProgressHUD.showFailed("Host roll back: \(UserDefaults.host.rawValue)")
                }
            } receiveValue: { [weak self] model in
                guard let data = model.data else { return }
                self?.dataSource = data
            }.store(in: &cancellables)
    }

    lazy var refreshImages: [UIImage] = {
        var images = [UIImage]()
        for i in 0...19 {
            let imageName = "refresh_\(i)"
            if let image = UIImage(named: imageName) {
                images.append(image)
            }
        }
        return images
    }()

}
