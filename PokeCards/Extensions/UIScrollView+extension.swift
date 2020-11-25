//
//  UIScrollView+extension.swift
//  PokeCards
//
//  Created by Vahid on 22/11/2020.
//

import UIKit

extension UIScrollView {
    func isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        contentOffset.y + frame.size.height + edgeOffset > contentSize.height
    }

    func isAtBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        contentOffset.y + frame.size.height + edgeOffset == contentSize.height
    }
}
