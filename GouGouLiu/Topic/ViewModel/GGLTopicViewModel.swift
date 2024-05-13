//
//  GGLTopicViewModel.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/29/23.
//

import Foundation
import RxSwift
import Moya
import Combine

final class GGLTopicViewModel {

    private let moyaProvider = MoyaProvider<GGLTopicAPI>()
    private var cancellables = Set<AnyCancellable>()
    private(set) var updateSubject = PublishSubject<GGLHomePostModel?>()
    var postModel: GGLHomePostModel?

    func getPostData() {
        guard let postId = postModel?.post?.postId else { return }
        requestPostData(postId: postId, completion: { [weak self] model in
            guard let data = model.data,
                  let self = self else { return }
            postModel?.post = data
            updateSubject.onNext(postModel)
        })
    }

    private func requestPostData(postId: String, completion: @escaping (GGLMoyaModel<GGLPostModel>) -> Void) {
        moyaProvider.requestPublisher(GGLTopicAPI(postId: postId))
            .map(GGLMoyaModel<GGLPostModel>.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { completion($0) })
            .store(in: &cancellables)
    }

}
