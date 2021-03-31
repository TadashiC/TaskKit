//
//  Taskable+Pair.swift
//  TaskKit
//
//  Created by Tadashi.Chiu on 2020/05/07.
//

import Foundation

// MARK: - Taskable
public extension Taskable {
    func pair<Other: Taskable>(_ other: Other) -> Pair<Self, Other> {
        return Pair(self, other)
    }
    
    func pair<Other: Taskable>(_ other: () -> Other) -> Pair<Self, Other> {
        return Pair(self, other())
    }
}

// MARK: - Pair
extension Pair: Taskable where Current: Taskable, Other: Taskable {
    public typealias TaskRequest = (Current.TaskRequest, Other.TaskRequest)
    public typealias TaskValue = (Current.TaskValue, Other.TaskValue)
    public typealias TaskError = Error
    
    public func request(_ request: TaskRequest, _ recieve: @escaping ResultHandler<TaskValue, TaskError>) {
        
        let group = DispatchGroup()
        
        var currentResult: Result<Current.TaskValue, Current.TaskError>!
        var otherResult: Result<Other.TaskValue, Other.TaskError>!
        
        defer {
            group.notify(queue: .main) {
                recieve(ResultType(current: currentResult, other: otherResult).result)
            }
        }
        
        group.enter()
        current.request(request.0) {
            currentResult = $0
            group.leave()
        }
        
        group.enter()
        other.request(request.1) {
            otherResult = $0
            group.leave()
        }
    }
    
    private struct ResultType {
        let current: Result<Current.TaskValue, Current.TaskError>
        let other: Result<Other.TaskValue, Other.TaskError>
        
        var result: Result<TaskValue, TaskError> {
            switch (current, other) {
            case let (.success(current), .success(other)):
                return .success(TaskValue(current, other))
            case (_, .failure(let (error as Error))), (.failure(let (error as Error)), _):
                return .failure(error)
            }
        }
    }
}
