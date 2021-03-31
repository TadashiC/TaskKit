//
//  Cacheable.swift
//  TaskKit
//
//  Created by Tadashi.Chiu on 2020/06/29.
//

import Foundation

public protocol Cacheable: AnyObject {
    associatedtype CacheRequest
    associatedtype CacheValue
    
    func get(_ parameter: CacheRequest, _ value: @escaping (CacheValue?) -> Void)
    
    func cache(_ pair: (CacheRequest, CacheValue), _ value: @escaping (CacheValue) -> Void)
}
