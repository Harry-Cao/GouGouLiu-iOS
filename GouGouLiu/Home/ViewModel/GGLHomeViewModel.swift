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
        })
    }

    private func fetchHomePostData() -> Observable<GGLMoyaModel<[GGLHomePostModel]>> {
        let api = GGLHomePostAPI()
        return moyaProvider.observable.request(api)
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
