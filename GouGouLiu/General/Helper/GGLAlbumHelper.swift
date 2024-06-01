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

    static func getAlbum(title: String, completion: @escaping (PHAssetCollection?) -> Void) {
        if let album = fetchAlbum(title: title) {
            completion(album)
        } else {
            createAlbum(title: title) { album in
                completion(album)
            }
        }
    }

    private static func fetchAlbum(title: String) -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", title)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        return collection.firstObject
    }

    private static func createAlbum(title: String, completion: @escaping (PHAssetCollection?) -> Void) {
        var albumPlaceholder: PHObjectPlaceholder?
        PHPhotoLibrary.shared().performChanges {
            let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: title)
            albumPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
        } completionHandler: { _, _ in
            if let placeholder = albumPlaceholder {
                let fetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [placeholder.localIdentifier], options: nil)
                completion(fetchResult.firstObject)
            } else {
                completion(nil)
            }
        }
    }

    /// Support naming the photo
    static func saveImage(fileUrl: URL, toAlbum album: PHAssetCollection? = nil, completion: ((Bool) -> Void)? = nil) {
        PHPhotoLibrary.shared().performChanges {
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
        } completionHandler: { success, _ in
            completion?(success)
        }
    }

    /// Could not name the photo
    static func saveImage(image: UIImage, toAlbum album: PHAssetCollection? = nil, completion: ((Bool) -> Void)? = nil) {
        PHPhotoLibrary.shared().performChanges {
            let assetChangeRequest: PHAssetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            assetChangeRequest.creationDate = Date()
            if let album = album, album.assetCollectionType == .album {
                let placeHolder = assetChangeRequest.placeholderForCreatedAsset
                let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
                albumChangeRequest?.addAssets([placeHolder] as NSFastEnumeration)
            }
        } completionHandler: { success, _ in
            completion?(success)
        }
    }
}
