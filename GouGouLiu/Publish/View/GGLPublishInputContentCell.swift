//
//  GGLPublishInputContentCell.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/26/23.
//

import UIKit

final class GGLPublishInputContentCell: GGLBaseTableViewCell {

    private lazy var inputTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.delegate = self
        textView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        textView.tintColor = .systemYellow
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
        [inputTextView].forEach(contentView.addSubview)
        inputTextView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(100)
        }
    }

}

extension GGLPublishInputContentCell: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        GGLPublishManager.shared.cacheContent = textView.text
    }

}
