//
//  GGLTabBarController+Message.swift
//  GouGouLiu
//
//  Created by Harry Cao on 3/17/24.
//

import Foundation

extension GGLTabBarController {
    func updateMessageUnReadNum() {
        let num = getUnReadNum()
        showMessageUnReadNum(num)
    }

    private func getUnReadNum() -> Int {
        guard let userId = GGLUser.getUserId(showHUD: false) else { return 0 }
        let messageModels = GGLDataBase.shared.fetchMessageModels(ownerId: userId)
        return messageModels.reduce(0) { partialResult, messageModel in
            partialResult + messageModel.unReadNum
        }
    }

    private func showMessageUnReadNum(_ unReadNum: Int) {
        let unReadNumString: String? = unReadNum > 0 ? String(unReadNum) : nil
        if let navigationController = viewControllers?.first(where: {
            guard let naVC = $0 as? GGLBaseNavigationController,
                  let viewController = naVC.viewControllers.first,
                  viewController.isKind(of: GGLMessageViewController.self) else { return false }
            return true
        }) as? GGLBaseNavigationController {
            navigationController.tabBarItem.badgeValue = unReadNumString
        }
    }
}
