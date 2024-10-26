//
//  GGLOrderViewModel.swift
//  GouGouLiu
//
//  Created by harry.weixian.cao on 2024/8/27.
//

import Foundation

final class GGLOrderViewModel {
    let itemSpacing: CGFloat = 12.0
    let sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    @Published private(set) var dataSource = [GGLOrderModel]()

    private var insetWidth: CGFloat {
        sectionInset.left + sectionInset.right
    }

    var itemWidth: CGFloat {
        let screenWidth = mainWindow.bounds.width - mainWindow.safeAreaInsets.left - mainWindow.safeAreaInsets.right
        let itemCount = CGFloat(itemCount(screenWidth: screenWidth))
        return (screenWidth + itemSpacing - insetWidth - itemSpacing * itemCount) / itemCount
    }

    func itemCount(screenWidth: CGFloat) -> Int {
        let count = Int((screenWidth + itemSpacing - insetWidth) / (GGLOrderCell.minWidth + itemSpacing))
        return max(1, count)
    }
}
