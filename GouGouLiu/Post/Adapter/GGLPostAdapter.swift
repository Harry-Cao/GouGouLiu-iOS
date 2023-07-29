//
//  GGLPostAdapter.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/25/23.
//

import UIKit

final class GGLPostAdapter: NSObject {

    let cellTypes: [PostCellType] = [.uploadPhoto, .inputTitle, .inputContent]
    weak var tableView: UITableView? {
        didSet {
            tableView?.dataSource = self
            tableView?.delegate = self
            tableView?.register(GGLPostUploadPhotoCell.self, forCellReuseIdentifier: "\(GGLPostUploadPhotoCell.self)")
            tableView?.register(GGLPostInputTitleCell.self, forCellReuseIdentifier: "\(GGLPostInputTitleCell.self)")
            tableView?.register(GGLPostInputContentCell.self, forCellReuseIdentifier: "\(GGLPostInputContentCell.self)")
        }
    }
    var uploadPhotoCellConfigurator: ((_ uploadPhotoCell: GGLPostUploadPhotoCell) -> Void)?
    var uploadPhotoCellSelectedHandler: ((_ urlString: String?) -> Void)?

}

// MARK: - UITableViewDataSource
extension GGLPostAdapter: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTypes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        let cellType = cellTypes[indexPath.row]
        switch cellType {
        case .uploadPhoto:
            let uploadPhotoCell: GGLPostUploadPhotoCell = tableView.dequeueReusableCell(for: indexPath)
            uploadPhotoCell.delegate = self
            uploadPhotoCellConfigurator?(uploadPhotoCell)
            cell = uploadPhotoCell
        case .inputTitle:
            let inputTitleCell: GGLPostInputTitleCell = tableView.dequeueReusableCell(for: indexPath)
            cell = inputTitleCell
        case .inputContent:
            let inputContentCell: GGLPostInputContentCell = tableView.dequeueReusableCell(for: indexPath)
            cell = inputContentCell
        }
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

// MARK: - GGLPostUploadPhotoCellDelegate
extension GGLPostAdapter: GGLPostUploadPhotoCellDelegate {

    func didSelectItem(urlString: String?) {
        uploadPhotoCellSelectedHandler?(urlString)
    }

}

extension GGLPostAdapter {

    enum PostCellType {
        case uploadPhoto
        case inputTitle
        case inputContent
    }

}
