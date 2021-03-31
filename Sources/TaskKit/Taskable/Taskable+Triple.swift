//
//  Taskable+Triple.swift
//  TaskKit
//
//  Created by Tadashi.Chiu on 2020/06/30.
//

import Foundation

// MARK: - Taskable
public extension Taskable {
    func triple<Other: Taskable, Another: Taskable>(_ other: Other, _ another: Another) -> Triple<Self, Other, Another> {
        return Triple(self, other, another)
    }
    
    func triple<Other: Taskable, Another: Taskable>(_ other: () -> (Other, Another)) -> Triple<Self, Other, Another> {
        let pair = other()
        return Triple(self, pair.0, pair.1)
    }
}

// MARK: - Triple
extension Triple: Taskable where Current: Taskable, Other: Taskable, Another: Taskable {
    public typealias TaskRequest = (Current.TaskRequest, Other.TaskRequest, Another.TaskRequest)
    public typealias TaskValue = (Current.TaskValue, Other.TaskValue, Another.TaskValue)
    public typealias TaskError = Error
    
    public func request(_ request: TaskRequest, _ recieve: @escaping ResultHandler<TaskValue, TaskError>) {
        
        let group = DispatchGroup()
        
        var currentResult: Result<Current.TaskValue, Current.TaskError>!
        var otherResult: Result<Other.TaskValue, Other.TaskError>!
        var anotherResult: Result<Another.TaskValue, Another.TaskError>!
        
        defer {
            group.notify(queue: .main) {
                recieve(ResultType(current: currentResult, other: otherResult, another: anotherResult).result)
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
        
        group.enter()
        another.request(request.2) {
            anotherResult = $0
            group.leave()
        }
    }
    
    private struct ResultType {
        let current: Result<Current.TaskValue, Current.TaskError>
        let other: Result<Other.TaskValue, Other.TaskError>
        let another: Result<Another.TaskValue, Another.TaskError>
        
        var result: Result<TaskValue, TaskError> {
            switch (current, other, another) {
            case let (.success(current), .success(other), .success(another)):
                return .success(TaskValue(current, other, another))
            case (_, .failure(let (error as Error)), _), (.failure(let (error as Error)), _, _), (_, _, .failure(let (error as Error))):
                return .failure(error)
            }
        }
    }
}
