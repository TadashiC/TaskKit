//
//  AnyTask.swift
//  TaskKit
//
//  Created by Tadashi.Chiu on 2020/06/01.
//

import Foundation

public class AnyTask<In, Out, Failure: Error>: Taskable {
    public typealias TaskRequest = In
    public typealias TaskValue = Out
    public typealias TaskError = Failure
    
    public typealias Handler = (In, @escaping ResultHandler<Out, Failure>) -> Void
    
    private var handler: Handler = { _, _ in }
    private var isCancel: Bool = false
    
    public required init(_ handler: @escaping Handler) {
        self.handler = handler
    }
    
    public convenience init(_ validate: @escaping (In) -> Result<Out, Failure>) {
        self.init { $1(validate($0)) }
    }
    
    public func request(_ request: TaskRequest, _ recieve: @escaping ResultHandler<TaskValue, TaskError>) {
        handler(request) { [weak self] in
            if self?.isCancel == true { return }
            recieve($0)
        }
    }
    
    public func cancel() {
        isCancel = true
    }
}

extension AnyTask where In == Void {
    static func void(_ value: Out) -> Self {
        return self.init {
            $1(.success(value))
        }
    }
}

extension AnyTask where In == Out {
    convenience init() {
        self.init {
            $1(.success($0))
        }
    }
}

extension AnyTask {
    convenience init<T: Taskable>(_ task: T) where T.TaskRequest == In, T.TaskValue == Out, T.TaskError == Failure {
        self.init { input, callbask in
            task.request(input) {
                callbask($0)
            }
        }
    }
    
    convenience init<T: Taskable>(_ task: @escaping () -> T) where T.TaskRequest == In, T.TaskValue == Out, T.TaskError == Failure {
        self.init { input, callbask in
            task().request(input) {
                callbask($0.mapError { $0 })
            }
        }
    }
}
