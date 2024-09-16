//
//  GGLPersonalRowCell.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/9/16.
//

import UIKit
import SnapKit

final class GGLPersonalRowCell: UITableViewCell {
    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        [iconImageView, titleLabel].forEach(contentView.addSubview)
        iconImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(24)
            make.size.equalTo(24)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(iconImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(24)
        }
    }

    func setup(row: GGLPersonalViewModel.SettingRow) {
        titleLabel.text = row.title
        titleLabel.textColor = row.foregroundColor
        iconImageView.image = UIImage(systemName: row.iconName)
        iconImageView.tintColor = row.foregroundColor
    }
}
