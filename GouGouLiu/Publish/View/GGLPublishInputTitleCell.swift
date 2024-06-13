//
//  GGLPublishInputTitleCell.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/26/23.
//

import UIKit

final class GGLPublishInputTitleCell: GGLBaseTableViewCell {

    private lazy var inputTestField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "填写标题会有更多赞哦~"
        textField.addTarget(self, action: #selector(inputDidChanged(textField:)), for: .editingChanged)
        textField.tintColor = .systemYellow
        return textField
    }()
    private let dividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = .opaqueSeparator
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        [inputTestField, dividerLine].forEach(contentView.addSubview)
        inputTestField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview()
            make.height.equalTo(48)
        }
        dividerLine.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(1)
        }
    }

    @objc private func inputDidChanged(textField: UITextField) {
        GGLPublishManager.shared.cacheTitle = textField.text
    }

}
