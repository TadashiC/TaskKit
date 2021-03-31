//
//  Taskable+Cache.swift
//  TaskKit
//
//  Created by Tadashi.Chiu on 2020/06/30.
//

import Foundation

// MARK: - Taskable
public extension Taskable {
    func cache<Other: Cacheable>(_ other: Other) -> Cache<Self, Other> where Self.TaskRequest == Other.CacheRequest, Self.TaskValue == Other.CacheValue {
        return Cache(self, other)
    }
    
    func cache<Other: Cacheable>(_ other: () -> Other) -> Cache<Self, Other> where Self.TaskRequest == Other.CacheRequest, Self.TaskValue == Other.CacheValue {
        return Cache(self, other())
    }
}

// MARK: - Cache
extension Cache: Taskable where Current: Taskable, Other: Cacheable, Current.TaskRequest == Other.CacheRequest, Current.TaskValue == Other.CacheValue {
    public typealias TaskRequest = Current.TaskRequest
    public typealias TaskValue = Current.TaskValue
    public typealias TaskError =  Error
    
    public func request(_ request: TaskRequest, _ recieve: @escaping ResultHandler<TaskValue, TaskError>) {
        let current = self.current
        let other = self.other
        other.get(request) {
            switch $0 {
            case .some(let value): return recieve(.success(value))
            case .none:
                current.request(request) {
                    switch $0 {
                    case .failure(let error): return recieve(.failure(error))
                    case .success(let value):
                        other.cache((request, value)) { return recieve(.success($0)) }
                    }
                }
            }
        }
    }
}
