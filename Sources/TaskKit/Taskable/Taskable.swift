//
//  Taskable.swift
//  TaskKit
//
//  Created by Tadashi.Chiu on 2020/06/01.
//

import Foundation

/// Taskable
public protocol Taskable {
    associatedtype TaskRequest
    associatedtype TaskValue
    associatedtype TaskError: Error
    
    /// request with `TaskRequest`
    /// - Parameters:
    ///   - request: `TaskRequest`
    ///   - response: `Response`
    func request(_ request: TaskRequest, _ recieve: @escaping ResultHandler<TaskValue, TaskError>)

}

extension Taskable {
    public func asTask() -> AnyTask<TaskRequest, TaskValue, TaskError> {
        return AnyTask(self)
    }
    
    public func request(_ request: TaskRequest, _ response: @escaping ReponseResultHandler<TaskRequest, TaskValue, TaskError>) {
        self.request(request) {
            response(.init(request: request, value: $0))
        }
    }
}

extension AnyOperation {
    convenience init<T: Taskable>(_ task: T) where T.TaskValue == Out, T.TaskRequest == In {
        self.init { config, callbask in
            task.request(config) {
                callbask($0.mapError { $0 })
            }
        }
    }
}
