//
//  Taskable+Else.swift
//  TaskKit
//
//  Created by Tadashi.Chiu on 2020/06/30.
//

import Foundation

// MARK: - Taskable
public extension Taskable {
    func `else`<Other: Taskable>(_ other: Other) -> Else<Self, Other> where Self.TaskRequest == Other.TaskRequest, Self.TaskValue == Other.TaskValue {
        return Else(self, other)
    }
    
    func `else`<Other: Taskable>(_ other: () -> Other) -> Else<Self, Other> where Self.TaskRequest == Other.TaskRequest, Self.TaskValue == Other.TaskValue {
        return Else(self, other())
    }
}

// MARK: - Else
extension Else: Taskable where Current: Taskable, Other: Taskable, Current.TaskRequest == Other.TaskRequest, Current.TaskValue == Other.TaskValue {
    public typealias TaskRequest = Current.TaskRequest
    public typealias TaskValue = Current.TaskValue
    public typealias TaskError =  Error
    
    public func request(_ request: TaskRequest, _ recieve: @escaping ResultHandler<TaskValue, TaskError>) {
        let other = self.other
        current.request(request) {
            switch $0 {
            case .success(let value):
                return recieve(.success(value))
            case .failure:
                other.request(request) {
                    switch $0 {
                    case .success(let value):
                        return recieve(.success(value))
                    case .failure(let error):
                        return recieve(.failure(error))
                    }
                }
            }
        }
    }
}
