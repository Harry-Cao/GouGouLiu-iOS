//
//  GGLHomeViewModel.swift
//  GouGouLiu
//
//  Created by Harry Cao on 2023/7/5.
//

import UIKit
import RxSwift
import Moya

final class GGLHomeViewModel {

    private(set) var dataSource: [GGLHomePostModel] = []
    private let moyaProvider = MoyaProvider<GGLHomePostAPI>()
    private(set) var updateSubject: PublishSubject<[GGLHomePostModel]> = PublishSubject<[GGLHomePostModel]>()

    func getHomePostData() {
        let _ = fetchHomePostData().subscribe(onNext: { [weak self] model in
            guard let data = model.data else { return }
            self?.dataSource = data
            self?.updateSubject.onNext(data)
        }, onError: { _ in
            if UserDefaults.host == .intranet {
                UserDefaults.host = .internet
                ProgressHUD.showFailed("Host roll back: \(UserDefaults.host.rawValue)")
            }
        })
    }

    private func fetchHomePostData() -> Observable<GGLMoyaModel<[GGLHomePostModel]>> {
        let api = GGLHomePostAPI()
        return MoyaProvider<GGLHomePostAPI>(session: GGLAlamofireSession.shared).observable.request(api)
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
