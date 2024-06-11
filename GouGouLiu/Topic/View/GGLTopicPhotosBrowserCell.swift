//
//  GGLTopicPhotosBrowserCell.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/29/23.
//

import Foundation

final class GGLTopicPhotosBrowserCell: GGLBaseTableViewCell {

    private(set) var browserView = GGLWebImageBrowser()

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
        }
    }

    func setup(imageModels: [GGLWebImageModel], failToGestures: [UIGestureRecognizer], height: CGFloat) {
        browserView.imageModels = imageModels
        browserView.failToGestures = failToGestures
        if browserView.bounds.height != height {
            browserView.snp.makeConstraints { make in
                make.height.equalTo(height)
            }
        }
    }

}
