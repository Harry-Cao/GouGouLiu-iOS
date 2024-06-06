import Foundation
import SDWebImage

extension GGLPhotoDownloadManager {
    typealias GGLPhotoDownloadQueueProgressBlock = (_ index: Int, _ total: Int, _ success: Bool) -> Void
    typealias GGLPhotoDownloadCompletedBlock = (_ allSuccess: Bool, _ failUrlStrings: [String]?) -> Void
}

final class GGLPhotoDownloadManager {
    static let shared = GGLPhotoDownloadManager()
    private let albumTitle: String = .app_name
    private var downloadMissions = [DownloadMission]()
    private var progressBlock: SDImageLoaderProgressBlock?
    private var queueProgressBlock: GGLPhotoDownloadQueueProgressBlock?
    private var completedBlock: GGLPhotoDownloadCompletedBlock?
    private var isPause: Bool = false
    private var failUrlStrings: [String] {
        return downloadMissions.compactMap({ $0.status != .success ? $0.urlString : nil })
    }

    func downloadPhotosToAlbum(urls: [String],
                               progress progressBlock: SDImageLoaderProgressBlock? = nil,
                               queueProgress queueProgressBlock: GGLPhotoDownloadQueueProgressBlock? = nil,
                               completed completedBlock: GGLPhotoDownloadCompletedBlock? = nil) {
        SDWebImageDownloader.shared.cancelAllDownloads()
        self.downloadMissions = urls.map({ DownloadMission(urlString: $0) })
        self.progressBlock = progressBlock
        self.queueProgressBlock = queueProgressBlock
        self.completedBlock = completedBlock
        startDownloading()
    }

    private func startNextMission() async {
        guard !isPause else { return }
        guard let missionIndex = downloadMissions.firstIndex(where: { $0.status == .waiting }) else {
            let failUrlStrings = self.failUrlStrings
            completedBlock?(failUrlStrings.isEmpty, failUrlStrings)
            return
        }
        let mission = downloadMissions[missionIndex]
        do {
            mission.status = .downloading
            let fileUrl = try await downloadImage(url: mission.urlString, progress: progressBlock)
            let album = try await GGLAlbumHelper.getAlbum(title: albumTitle)
            try await GGLAlbumHelper.saveImage(fileUrl: fileUrl, toAlbum: album)
            mission.status = .success
        } catch {
            mission.status = .failed
        }
        queueProgressBlock?(missionIndex, downloadMissions.count, mission.status == .success)
        await startNextMission()
    }

    private func downloadImage(url: String, progress: SDImageLoaderProgressBlock?) async throws -> URL {
        return try await withCheckedThrowingContinuation { continuation in
            SDWebImageManager.shared.loadImage(with: URL(string: url), progress: progress) { _, _, error, _, _, _ in
                if let cachePath = SDImageCache.shared.cachePath(forKey: url),
                   let fileUrl = URL(string: cachePath) {
                    continuation.resume(returning: fileUrl)
                } else {
                    continuation.resume(throwing: error ?? DownloadError.unknown)
                }
            }
        }
    }

    func startDownloading() {
        isPause = false
        Task {
            await startNextMission()
        }
    }

    func pauseDownloading() {
        isPause = true
    }

    func cancelDownloading() {
        SDWebImageDownloader.shared.cancelAllDownloads()
        let failUrlStrings = self.failUrlStrings
        completedBlock?(failUrlStrings.isEmpty, failUrlStrings)
    }
}

extension GGLPhotoDownloadManager {
    final class DownloadMission {
        let urlString: String
        var status: MissionStatus = .waiting

        init(urlString: String) {
            self.urlString = urlString
        }
    }

    enum MissionStatus {
        case waiting
        case downloading
        case failed
        case success
    }

    enum DownloadError: Error {
        case unknown
    }
}
