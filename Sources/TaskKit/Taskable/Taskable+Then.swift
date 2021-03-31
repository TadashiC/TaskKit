//
//  Taskable+Then.swift
//  TaskKit
//
//  Created by Tadashi.Chiu on 2020/06/01.
//

import Foundation

// MARK: - Taskable
public extension Taskable {
    func then<Other: Taskable>(_ other: Other) -> Then<Self, Other> where Self.TaskValue == Other.TaskRequest {
        return Then(self, other)
    }
    
    func then<Other: Taskable>(_ other: () -> Other) -> Then<Self, Other> where Self.TaskValue == Other.TaskRequest {
        return Then(self, other())
    }
}

// MARK: - Then
extension Then: Taskable where Current: Taskable, Other: Taskable, Current.TaskValue == Other.TaskRequest {
    public typealias TaskRequest = Current.TaskRequest
    public typealias TaskValue = Other.TaskValue
    public typealias TaskError =  Error
    
    public func request(_ request: TaskRequest, _ recieve: @escaping ResultHandler<TaskValue, TaskError>) {
        let other = self.other
        current.request(request) {
            switch $0 {
            case .success(let value):
                other.request(value) {
                    switch $0 {
                    case .success(let value):
                        return recieve(.success(value))
                    case .failure(let error):
                        return recieve(.failure(error))
                    }
                }
            case .failure(let error):
                return recieve(.failure(error))
            }
        }
    }
}
