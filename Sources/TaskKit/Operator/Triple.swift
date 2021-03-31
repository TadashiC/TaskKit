//
//  Triple.swift
//  TaskKit
//
//  Created by Tadashi.Chiu on 2020/06/01.
//

import Foundation

public class Triple<Current, Other, Another> {
    let current: Current
    let other: Other
    let another: Another
    
    init(_ current: Current, _ other: Other, _ another: Another) {
        self.current = current
        self.other = other
        self.another = another
    }
}
