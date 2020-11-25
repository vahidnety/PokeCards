//
//  UITableView+extension.swift
//  PokeCards
//
//  Created by Vahid on 22/11/2020.
//

import Foundation
import UIKit

extension UITableView {
    func registerCellNib(_ cellClass: AnyClass) {
        let identifier = NSStringFromClass(cellClass).components(separatedBy: ".").last!
        let nib = UINib(nibName: identifier, bundle: nil)
        register(nib, forCellReuseIdentifier: identifier)
    }
}
