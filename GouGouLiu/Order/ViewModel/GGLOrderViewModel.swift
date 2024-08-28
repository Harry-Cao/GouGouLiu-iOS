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

    func mockData() {
        let dog = GGLDogModel()
        dog.name = "Cotton"
        dog.avatarUrl = "http://f3.ttkt.cc:12873/GGLServer/media/global/customer_service.jpeg"
        let mockModel = GGLOrderModel(type: .walkingDog, isRealTime: false, dogs: [dog], requirements: "Please walk my dog at least two hours.")
        for _ in 0...100 {
            dataSource.append(mockModel)
        }
    }

    var itemWidth: CGFloat {
        let screenWidth = mainWindow.bounds.width
        let itemCount = CGFloat(itemCount(screenWidth: screenWidth))
        return (screenWidth + itemSpacing - insetWidth - itemSpacing * itemCount) / itemCount
    }

    func itemCount(screenWidth: CGFloat) -> Int {
        let count = Int((screenWidth + itemSpacing - insetWidth) / (GGLOrderCell.minWidth + itemSpacing))
        return max(1, count)
    }
}
