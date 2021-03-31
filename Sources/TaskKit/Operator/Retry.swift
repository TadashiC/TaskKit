//
//  Retry.swift
//  TaskKit
//
//  Created by Tadashi.Chiu on 2020/06/29.
//

import Foundation

public class Retry<Current> {
    let current: Current
    let count: Int
    
    init(_ current: Current, _ count: Int = 0) {
        self.current = current
        self.count = count
    }
}
