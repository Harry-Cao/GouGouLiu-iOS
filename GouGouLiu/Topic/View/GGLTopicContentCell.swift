//
//  GGLTopicContentCell.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/29/23.
//

import UIKit

final class GGLTopicContentCell: GGLBaseTableViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [titleLabel, contentLabel].forEach(mainStackView.addArrangedSubview)
        [mainStackView].forEach(contentView.addSubview)
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
    
    func setup(title: String?, content: String?) {
        titleLabel.text = title
        contentLabel.text = content
    }

}
