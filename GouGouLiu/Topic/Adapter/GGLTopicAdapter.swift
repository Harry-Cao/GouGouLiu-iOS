//
//  GGLTopicAdapter.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/29/23.
//

import Foundation

final class GGLTopicAdapter: NSObject {

    let cellTypes: [TopicCellType] = [.photos, .content]
    weak var tableView: UITableView? {
        didSet {
            tableView?.dataSource = self
            tableView?.delegate = self
            tableView?.register(GGLTopicPhotosBrowserCell.self, forCellReuseIdentifier: "\(GGLTopicPhotosBrowserCell.self)")
            tableView?.register(GGLTopicContentCell.self, forCellReuseIdentifier: "\(GGLTopicContentCell.self)")
        }
    }
    var photoBrowserCellConfigurator: ((_ photoBrowserCell: GGLTopicPhotosBrowserCell)->Void)?
    var contentCellConfigurator: ((_ contentCell: GGLTopicContentCell)->Void)?
    var photoBrowserCellDidSelectHandler: ((_ browser: GGLWebImageBrowser, _ index: Int)->Void)?

}

// MARK: - UITableViewDataSource
extension GGLTopicAdapter: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTypes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = cellTypes[indexPath.row]
        switch cellType {
        case .photos:
            let photoBrowserCell: GGLTopicPhotosBrowserCell = tableView.dequeueReusableCell(for: indexPath)
            photoBrowserCellConfigurator?(photoBrowserCell)
            photoBrowserCell.browserView.delegate = self
            return photoBrowserCell
        case .content:
            let contentCell: GGLTopicContentCell = tableView.dequeueReusableCell(for: indexPath)
            contentCellConfigurator?(contentCell)
            return contentCell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

// MARK: - GGLWebImageBrowserDelegate
extension GGLTopicAdapter: GGLWebImageBrowserDelegate {

    func imageBrowserView(_ imageBrowserView: GGLWebImageBrowser, didSelectItemAt index: Int) {
        photoBrowserCellDidSelectHandler?(imageBrowserView, index)
    }

}

extension GGLTopicAdapter {

    enum TopicCellType {
        case photos
        case content
    }

}
