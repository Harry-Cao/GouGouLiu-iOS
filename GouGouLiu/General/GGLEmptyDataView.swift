//
//  GGLEmptyDataView.swift
//  GouGouLiu
//
//  Created by Harry Cao on 8/13/23.
//

import UIKit

protocol GGLEmptyDataViewDelegate: AnyObject {
    func didTapRefresh()
}

final class GGLEmptyDataView: UIView {

    weak var delegate: GGLEmptyDataViewDelegate?

    private let emptyDataImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .icon_empty_data
        return imageView
    }()
    private let refreshButton: UIButton = {
        let button = UIButton()
        button.setTitle("无数据，点击刷新", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .black)
        button.setTitleColor(.label, for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        [emptyDataImageView, refreshButton].forEach(addSubview)
        emptyDataImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        refreshButton.snp.makeConstraints { make in
            make.top.equalTo(emptyDataImageView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        refreshButton.addTarget(self, action: #selector(didTapRefresh), for: .touchUpInside)
    }

    @objc private func didTapRefresh() {
        delegate?.didTapRefresh()
    }

}
