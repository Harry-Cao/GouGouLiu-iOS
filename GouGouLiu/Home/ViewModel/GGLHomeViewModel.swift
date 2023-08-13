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
    private(set) var disposeBag = DisposeBag()
    private(set) var updateSubject: PublishSubject<[GGLHomePostModel]> = PublishSubject<[GGLHomePostModel]>()

    func getHomePostData() {
        fetchHomePostData().subscribe(onNext: { [weak self] model in
            guard let data = model.data else { return }
            self?.dataSource = data
            self?.updateSubject.onNext(data)
        }).disposed(by: disposeBag)
    }

    private func fetchHomePostData() -> Observable<GGLMoyaModel<[GGLHomePostModel]>> {
        let api = GGLHomePostAPI()
        return Observable<GGLMoyaModel<[GGLHomePostModel]>>.ofRequest(api: api, provider: moyaProvider)
    }

}
