//
//  GGLAlbumHelper.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/6/1.
//

import Foundation
import Photos

final class GGLAlbumHelper {
    private static var customNameForPhoto: String { "GGL_\(Date().timeIntervalSince1970)" }

    static func getAlbum(title: String) async throws -> PHAssetCollection? {
        if let album = fetchAlbum(title: title) {
            return album
        } else {
            return try await createAlbum(title: title)
        }
    }

    private static func fetchAlbum(title: String) -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", title)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        return collection.firstObject
    }

    private static func createAlbum(title: String) async throws -> PHAssetCollection? {
        var albumPlaceholder: PHObjectPlaceholder?
        try await PHPhotoLibrary.shared().performChanges {
            let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: title)
            albumPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
        }
        if let placeholder = albumPlaceholder {
            let fetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [placeholder.localIdentifier], options: nil)
            return fetchResult.firstObject
        }
        return nil
    }

    /// Support naming the photo
    static func saveImage(fileUrl: URL, toAlbum album: PHAssetCollection? = nil) async throws {
        try await PHPhotoLibrary.shared().performChanges {
            let assetChangeRequest = PHAssetCreationRequest.forAsset()
            assetChangeRequest.creationDate = Date()
            let option = PHAssetResourceCreationOptions()
            option.originalFilename = customNameForPhoto
            assetChangeRequest.addResource(with: .photo, fileURL: fileUrl, options: option)
            if let album = album, album.assetCollectionType == .album {
                let placeHolder = assetChangeRequest.placeholderForCreatedAsset
                let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
                albumChangeRequest?.addAssets([placeHolder] as NSFastEnumeration)
            }
        }
    }

    /// Could not name the photo
    static func saveImage(image: UIImage, toAlbum album: PHAssetCollection? = nil, completion: ((Bool) -> Void)? = nil) async throws {
        try await PHPhotoLibrary.shared().performChanges {
            let assetChangeRequest: PHAssetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            assetChangeRequest.creationDate = Date()
            if let album = album, album.assetCollectionType == .album {
                let placeHolder = assetChangeRequest.placeholderForCreatedAsset
                let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
                albumChangeRequest?.addAssets([placeHolder] as NSFastEnumeration)
            }
        }
    }
}
