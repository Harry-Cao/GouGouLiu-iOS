//
//  GGLTopicViewModel.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/29/23.
//

import Foundation
import RxSwift
import Moya

final class GGLTopicViewModel {

    private let moyaProvider = MoyaProvider<GGLTopicAPI>()
    private let disposeBag = DisposeBag()
    private(set) var updateSubject = PublishSubject<GGLHomePostModel?>()
    var postModel: GGLHomePostModel?

    func getPostData() {
        guard let postId = postModel?.postId else { return }
        requestPostData(postId: postId).subscribe(onNext: { [weak self] model in
            guard let data = model.data,
                  let self = self else { return }
            self.postModel = data
            self.updateSubject.onNext(data)
        }).disposed(by: disposeBag)
    }

    private func requestPostData(postId: String) -> Observable<GGLMoyaModel<GGLHomePostModel>> {
        let api = GGLTopicAPI(postId: postId)
        return .ofRequest(api: api, provider: moyaProvider)
    }

}
