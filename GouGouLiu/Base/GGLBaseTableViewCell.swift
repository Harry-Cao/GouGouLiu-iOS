//
//  GGLBaseTableViewCell.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/26/23.
//

import UIKit

class GGLBaseTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
