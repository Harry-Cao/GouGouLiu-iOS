//
//  UITableView+GGL.swift
//  GouGouLiu
//
//  Created by Harry Cao on 7/26/23.
//

import Foundation

extension UITableViewCell {

    static var cellReuseIdentifier: String { String(describing: self) }

}

extension UITableView {

    func register(_ cellClass: UITableViewCell.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.cellReuseIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.cellReuseIdentifier, for: indexPath) as? T else {
            fatalError("Cannot dequeueReusableCell of \(T.self) type!")
        }
        return cell
    }

}
