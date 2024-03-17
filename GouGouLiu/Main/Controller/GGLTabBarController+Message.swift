//
//  GGLTabBarController+Message.swift
//  GouGouLiu
//
//  Created by Harry Cao on 3/17/24.
//

import Foundation
import RxSwift

extension GGLTabBarController {
    func subscribe() {
        GGLDataBase.shared.messageUnReadSubject.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] num in
            guard let self else { return }
            updateUnReadNum(num)
        }).disposed(by: disposeBag)
        GGLUser.userStatusSubject.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            guard let self else { return }
            updateUnReadNum()
        }).disposed(by: disposeBag)
    }

    func updateUnReadNum(_ unReadNum: Int? = nil) {
        let num = unReadNum ?? getUnReadNum()
        showUnReadNumView(num > 0)
        unReadNumView.text = String(num)
    }

    private func getUnReadNum() -> Int {
        guard let userId = GGLUser.getUserId(showHUD: false) else { return 0 }
        let messageModels = GGLDataBase.shared.fetchMessageModels(ownerId: userId)
        return messageModels.reduce(0) { partialResult, messageModel in
            partialResult + messageModel.unReadNum
        }
    }

    private func showUnReadNumView(_ show: Bool) {
        unReadNumView.isHidden = !show
        if show {
            remakeUnReadNumViewConstraints()
        }
    }

    private func remakeUnReadNumViewConstraints() {
        unReadNumView.removeFromSuperview()
        if let index = viewControllers?.firstIndex(where: {
            guard let navigationController = $0 as? GGLBaseNavigationController,
                  let viewController = navigationController.viewControllers.first,
                  viewController.isKind(of: GGLMessageViewController.self) else { return false }
            return true
        }) {
            let messageItem = tabBarButtons[index]
            if let itemImageView = messageItem.subviews.first {
                messageItem.addSubview(unReadNumView)
                unReadNumView.snp.remakeConstraints {
                    $0.leading.equalTo(itemImageView.snp.trailing).offset(-4)
                    $0.top.equalToSuperview()
                    $0.height.equalTo(16)
                    $0.width.greaterThanOrEqualTo(16)
                }
            }
        }
    }
}
