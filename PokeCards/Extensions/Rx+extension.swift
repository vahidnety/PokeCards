//
//  UIScrollView+extension.swift
//  PokeCards
//
//  Created by Vahid on 22/11/2020.
//

import RxCocoa
import RxSwift

extension BehaviorRelay where Element: RangeReplaceableCollection {
    func acceptAppending(_ element: Element.Element) {
        accept(value + [element])
    }
}
