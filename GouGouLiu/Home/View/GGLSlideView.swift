//
//  GGLSlideView.swift
//  GouGouLiu
//
//  Created by HarryCao on 2024/4/19.
//

import Foundation

protocol GGLSlideViewDelegate: AnyObject {
    func onClickRemove()
}

final class GGLSlideView: UIView {
    static let width: CGFloat = 300
    weak var delegate: GGLSlideViewDelegate?
    private let contentView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: -width, y: 0, width: width, height: UIScreen.main.bounds.height)
        view.isUserInteractionEnabled = true
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(contentView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.onClickRemove()
    }

    func showToView(_ view: UIView) {
        view.addSubview(self)
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = .black.withAlphaComponent(0.2)
        }
    }

    func remove() {
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = .clear
        } completion: { flag in
            self.removeFromSuperview()
        }
    }
}
