//
//  Map.swift
//  TaskKit
//
//  Created by Tadashi.Chiu on 2020/06/01.
//

import Foundation

public class Map<Current, ValueType, NewValueType> {
    let current: Current
    let map: (ValueType) -> NewValueType
    
    init(_ current: Current, _ map: @escaping (ValueType) -> NewValueType) {
        self.current = current
        self.map = map
    }
}
