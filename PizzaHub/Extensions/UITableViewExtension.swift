//
//  UITableViewExtension.swift
//  SampleApp
//
//  Created by Dmitry Khalitov on 12.10.2025.
//

import UIKit

extension UITableView {
//    func registerCell<Cell: UITableViewCell>(_ cellClass: Cell.Type) {
//        register(cellClass, forCellReuseIdentifier: cellClass.reuseID)
//    }
}

protocol Reusable {}

extension UITableView: Reusable { }

extension Reusable where Self: UITableViewCell {
    static var reuseID: String {
        return String.init(describing: self)
    }
}
