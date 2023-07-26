//
//  UICollectionView+GGL.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/26/23.
//

import Foundation

extension UICollectionViewCell {

    static var cellReuseIdentifier: String { String(describing: self) }

}

extension UICollectionView {

    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.cellReuseIdentifier, for: indexPath) as? T else {
            fatalError("Cannot dequeueReusableCell of \(T.self) type!")
        }
        return cell
    }

}
