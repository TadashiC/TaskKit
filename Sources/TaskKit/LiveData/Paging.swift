//
//  Paging.swift
//  TaskKit
//
//  Created by Tadashi.Chiu on 2020/06/01.
//

import Foundation

public protocol Pageable {
    var isEnd: Bool { get }
    func addNextPage(_ value: Self) -> Self
}

extension Array: Pageable {
    public var isEnd: Bool { return isEmpty }
    public func addNextPage(_ value: Array<Element>) -> Array<Element> {
        var mutable = self
        mutable.append(contentsOf: value)
        return mutable
    }
}

extension Optional: Pageable where Wrapped: Pageable {
    public var isEnd: Bool {
        switch self {
        case .some(let value):
            return value.isEnd
        case .none:
            return false
        }
    }
    public func addNextPage(_ value: Optional<Wrapped>) -> Optional<Wrapped> {
        switch (self, value) {
        case (.none, .none):
            return nil
        case let (value?, .none):
            return value
        case let (.none, value?):
            return value
        case let (lhs?, rhs?):
            return lhs.addNextPage(rhs)
        }
    }
}
