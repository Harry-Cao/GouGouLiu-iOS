//
//  GGLTopicViewModel.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/29/23.
//

import Foundation
import Combine
import Moya

final class GGLTopicViewModel {

    @Published private(set) var postModel: GGLHomePostModel
    private let coverImage: UIImage?
    private let moyaProvider = MoyaProvider<GGLTopicAPI>()
    private var cancellables = Set<AnyCancellable>()

    init(postModel: GGLHomePostModel, coverImage: UIImage?) {
        self.postModel = postModel
        self.coverImage = coverImage
    }

    func getPostData() {
        guard let postId = postModel.post?.postId else { return }
        requestPostData(postId: postId, completion: { [weak self] model in
            guard let data = model.data,
                  let self = self else { return }
            postModel.post = data
        })
    }

    private func requestPostData(postId: String, completion: @escaping (GGLMoyaModel<GGLPostModel>) -> Void) {
        moyaProvider.requestPublisher(GGLTopicAPI(postId: postId))
            .map(GGLMoyaModel<GGLPostModel>.self)
            .receive(on: DispatchQueue.main)
            .sinkWithDefaultErrorHandle(receiveValue: { completion($0) })
            .store(in: &cancellables)
    }

    var imageModels: [GGLWebImageModel] {
        postModel.post?.photos?.map({ GGLWebImageModel(imageUrl: $0.originalUrl, previewUrl: $0.previewUrl) }) ?? [GGLWebImageModel(placeholderImage: coverImage)]
    }

    lazy var browserCellHeight: CGFloat = {
        let defaultHeight = 4032/3024 * mainWindow.bounds.width
        if let coverImage = coverImage {
            let ratio = coverImage.size.height / coverImage.size.width
            return min(mainWindow.bounds.width * ratio, defaultHeight)
        } else {
            return defaultHeight
        }
    }()

}
