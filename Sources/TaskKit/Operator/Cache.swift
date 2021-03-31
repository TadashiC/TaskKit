//
//  Cache.swift
//  TaskKit
//
//  Created by Tadashi.Chiu on 2020/06/30.
//

import Foundation

public class Cache<Current, Other> {
    let current: Current
    let other: Other
    
    init(_ current: Current, _ other: Other) {
        self.current = current
        self.other = other
    }
}
