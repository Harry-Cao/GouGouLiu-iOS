//
//  GGLTopicPhotosBrowserCell.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/29/23.
//

import Foundation

final class GGLTopicPhotosBrowserCell: GGLBaseTableViewCell {

    private let imageHeight: CGFloat = 4032/3024 * mainWindow.bounds.width
    private(set) lazy var browserView: GGLWebImageBrowser = {
        let configuration = GGLWebImageBrowserConfiguration()
        configuration.imageHeight = imageHeight
        let browser = GGLWebImageBrowser(configuration: configuration)
        return browser
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        [browserView].forEach(contentView.addSubview)
        browserView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(imageHeight)
        }
    }

    func setup(imageModels: [GGLWebImageModel], failToGestures: [UIGestureRecognizer]) {
        browserView.imageModels = imageModels
        browserView.failToGestures = failToGestures
    }

}
