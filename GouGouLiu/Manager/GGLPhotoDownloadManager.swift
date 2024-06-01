import Foundation
import SDWebImage

extension GGLPhotoDownloadManager {
    typealias GGLPhotoDownloadProgressBlock = (_ receivedSize: Int, _ expectedSize: Int) -> Void
    typealias GGLPhotoDownloadQueueProgressBlock = (_ index: Int, _ total: Int, _ success: Bool) -> Void
    typealias GGLPhotoDownloadCompletedBlock = (_ allSuccess: Bool, _ failUrlStrings: [String]?) -> Void
}

final class GGLPhotoDownloadManager {

    static let shared: GGLPhotoDownloadManager = GGLPhotoDownloadManager()
    private var urlModels: [PhotoDownloadModel] = []
    private var workItems: [DispatchWorkItem] = []
    private var isPause: Bool = false
    private var progressBlock: GGLPhotoDownloadProgressBlock?
    private var completedBlock: GGLPhotoDownloadCompletedBlock?
    private var failUrlStrings: [String] {
        return urlModels.compactMap({ $0.isSaved ? nil : $0.urlString })
    }

    func downloadPhotosToAlbum(urls: [String],
                               progress progressBlock: GGLPhotoDownloadProgressBlock? = nil,
                               queueProgress queueProgressBlock: GGLPhotoDownloadQueueProgressBlock? = nil,
                               completed completedBlock: GGLPhotoDownloadCompletedBlock? = nil) {
        self.progressBlock = progressBlock
        self.completedBlock = completedBlock
        workItems.removeAll()
        guard !urls.isEmpty else {
            completedBlock?(true, nil)
            return
        }
        GGLAlbumManager.shared.getAlbum(title: .app_name) { album in
            self.urlModels = urls.map({ PhotoDownloadModel(urlString: $0) })
            urls.enumerated().forEach { (index, urlString) in
                let workItem = DispatchWorkItem {
                    SDWebImageManager.shared.loadImage(with: URL(string: urlString)) { receivedSize, expectedSize, _ in
                        progressBlock?(receivedSize, expectedSize)
                    } completed: { _, _, _, _, finished, imageUrl in
                        self.workItems.removeFirst()
                        if finished,
                           let cachePath = SDImageCache.shared.cachePath(forKey: imageUrl?.absoluteString),
                           let fileUrl = URL(string: cachePath) {
                            GGLAlbumManager.shared.saveImage(fileUrl: fileUrl, toAlbum: album) { success in
                                let urlModel = self.urlModels[index]
                                urlModel.isSaved = success
                                queueProgressBlock?(index, urls.count, success)
                                self.runNextWorkItem()
                            }
                        } else {
                            queueProgressBlock?(index, urls.count, false)
                            self.runNextWorkItem()
                        }
                    }
                }
                self.workItems.append(workItem)
            }
            self.startDownloading()
        }
    }

    private func runNextWorkItem() {
        guard !self.isPause else { return }
        if let workItem = self.workItems.first {
            workItem.perform()
        } else {
            let failUrlStrings = self.failUrlStrings
            completedBlock?(failUrlStrings.isEmpty, failUrlStrings)
        }
    }

    private func startDownloading() {
        isPause = false
        runNextWorkItem()
    }

    func pauseDownloading() {
        isPause = true
    }

    func resumeDownloading() {
        startDownloading()
    }

    func cancelDownloading() {
        SDWebImageDownloader.shared.cancelAllDownloads()
        let failUrlStrings = self.failUrlStrings
        completedBlock?(failUrlStrings.isEmpty, failUrlStrings)
    }

}

extension GGLPhotoDownloadManager {
    final class PhotoDownloadModel {
        let urlString: String
        var isSaved: Bool = false

        init(urlString: String) {
            self.urlString = urlString
        }
    }
}
