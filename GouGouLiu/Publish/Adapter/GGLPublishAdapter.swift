//
//  GGLPublishAdapter.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/25/23.
//

import UIKit

final class GGLPublishAdapter: NSObject {

    let cellTypes: [PostCellType] = [.uploadPhoto, .inputTitle, .inputContent]
    weak var tableView: UITableView? {
        didSet {
            tableView?.dataSource = self
            tableView?.delegate = self
            tableView?.register(GGLPublishUploadPhotoCell.self)
            tableView?.register(GGLPublishInputTitleCell.self)
            tableView?.register(GGLPublishInputContentCell.self)
        }
    }
    var uploadPhotoCellConfigurator: ((_ uploadPhotoCell: GGLPublishUploadPhotoCell) -> Void)?
    var uploadPhotoCellSelectedHandler: ((_ urlString: String?) -> Void)?

}

// MARK: - UITableViewDataSource
extension GGLPublishAdapter: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTypes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellType = cellTypes[safe: indexPath.row] else { return UITableViewCell() }
        switch cellType {
        case .uploadPhoto:
            let uploadPhotoCell: GGLPublishUploadPhotoCell = tableView.dequeueReusableCell(for: indexPath)
            uploadPhotoCell.delegate = self
            uploadPhotoCellConfigurator?(uploadPhotoCell)
            return uploadPhotoCell
        case .inputTitle:
            return tableView.dequeueReusableCell(for: indexPath) as GGLPublishInputTitleCell
        case .inputContent:
            return tableView.dequeueReusableCell(for: indexPath) as GGLPublishInputContentCell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

// MARK: - GGLPublishUploadPhotoCellDelegate
extension GGLPublishAdapter: GGLPublishUploadPhotoCellDelegate {

    func didSelectItem(urlString: String?) {
        uploadPhotoCellSelectedHandler?(urlString)
    }

}

extension GGLPublishAdapter {

    enum PostCellType {
        case uploadPhoto
        case inputTitle
        case inputContent
    }

}
