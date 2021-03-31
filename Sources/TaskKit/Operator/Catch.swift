//
//  Catch.swift
//  TaskKit
//
//  Created by Tadashi.Chiu on 2020/07/15.
//

import Foundation

public class Catch<Current, ValueType, NewValueType> {
    let current: Current
    let map: (ValueType) -> NewValueType
    
    init(_ current: Current, _ map: @escaping (ValueType) -> NewValueType) {
        self.current = current
        self.map = map
    }
}
