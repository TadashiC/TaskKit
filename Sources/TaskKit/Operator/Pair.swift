//
//  Pair.swift
//  TaskKit
//
//  Created by Tadashi.Chiu on 2020/06/01.
//

import Foundation

public class Pair<Current, Other> {
    let current: Current
    let other: Other
    
    init(_ current: Current, _ other: Other) {
        self.current = current
        self.other = other
    }
}
