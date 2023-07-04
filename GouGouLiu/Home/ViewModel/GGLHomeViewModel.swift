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

    private(set) var dataSource: [GGLHomePostModel_Data] = []
    private let moyaProvider = MoyaProvider<GGLHomePostAPI>()
    private(set) var disposeBag = DisposeBag()
    private(set) var updateSubject: PublishSubject<Any?> = PublishSubject<Any?>()

    func getHomePostData() {
        fetchHomePostData().subscribe(onNext: { [weak self] postModel in
            guard let data = postModel.data,
                  let self = self else { return }
            self.dataSource = data
            self.updateSubject.onNext(nil)
        }).disposed(by: disposeBag)
    }

    private func fetchHomePostData() -> Observable<GGLHomePostModel> {
        let api = GGLHomePostAPI()
        return Observable<GGLHomePostModel>.ofRequest(api: api, provider: moyaProvider)
    }

}
