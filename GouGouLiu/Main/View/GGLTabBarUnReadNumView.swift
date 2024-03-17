//
//  GGLTabBarUnReadNumView.swift
//  GouGouLiu
//
//  Created by Harry Cao on 3/17/24.
//

import Foundation

final class GGLTabBarUnReadNumView: UILabel {
    init() {
        super.init(frame: .zero)
        isHidden = true
        layer.cornerRadius = 8
        layer.masksToBounds = true
        backgroundColor = .red
        textColor = .white
        font = .tab_bar_unRead_num
        textAlignment = .center
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
