//
//  Taskable+Combine.swift
//  TaskKit
//
//  Created by Tadashi.Chiu on 2020/08/04.
//

import Foundation
import Combine

@available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
extension Publishers {
    enum Task {}
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
extension Subscriptions {
    enum Task {}
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
extension Subscribers {
    enum Task {}
}
