//
//  Taskable+Retry.swift
//  TaskKit
//
//  Created by Tadashi.Chiu on 2020/06/30.
//

import Foundation

// MARK: - Taskable
public extension Taskable {
    func retry(_ count: Int) -> Retry<Self> {
        return Retry(self, count)
    }
}

// MARK: - Retry
extension Retry: Taskable where Current: Taskable {
    public typealias TaskRequest = Current.TaskRequest
    public typealias TaskValue = Current.TaskValue
    public typealias TaskError = Error
    
    public func request(_ request: TaskRequest, _ recieve: @escaping ResultHandler<TaskValue, TaskError>) {
        Self.request(request, count: count, task: current, recieve)
    }
    
    private static func request(_ request: TaskRequest, count: Int, task: Current, _ recieve: @escaping ResultHandler<TaskValue, TaskError>) {
        task.request(request) {
            switch $0 {
            case .success(let value):
                return recieve(.success(value))
            case .failure where count > 0:
                self.request(request, count: count - 1, task: task, recieve)
            case .failure(let error):
                return recieve(.failure(error))
            }
        }
    }
}
