//
//  GGLPostInputTitleCell.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/26/23.
//

import UIKit

final class GGLPostInputTitleCell: GGLBaseTableViewCell {

    private lazy var inputTestField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "输入标题"
        textField.addTarget(self, action: #selector(inputDidChanged(textField:)), for: .editingChanged)
        return textField
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(inputTestField)
        inputTestField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview()
            make.height.equalTo(48)
        }
    }

    @objc private func inputDidChanged(textField: UITextField) {
        GGLPostManager.shared.cacheTitle = textField.text
    }

}
