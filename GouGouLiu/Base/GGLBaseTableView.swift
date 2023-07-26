//
//  GGLBaseTableView.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/26/23.
//

import UIKit

class GGLBaseTableView: UITableView {

    init() {
        super.init(frame: .zero, style: .plain)
        separatorStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
