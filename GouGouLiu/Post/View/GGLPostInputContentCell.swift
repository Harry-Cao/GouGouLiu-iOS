//
//  GGLPostInputContentCell.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/26/23.
//

import UIKit

final class GGLPostInputContentCell: GGLBaseTableViewCell {

    private lazy var inputTextView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.label.cgColor
        textView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return textView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(inputTextView)
        inputTextView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(100)
        }
    }

}

extension GGLPostInputContentCell: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        GGLPostManager.shared.cacheContent = textView.text
    }

}
