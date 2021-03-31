//
//  Taskable+Validate.swift
//  TaskKit
//
//  Created by Tadashi.Chiu on 2020/06/30.
//

import Foundation

// MARK: - Taskable
public extension Taskable {
    func validate<NewValueType>(_ validate: @escaping (Result<Response<Self.TaskRequest, Self.TaskValue>, Self.TaskError>) -> Result<NewValueType, Self.TaskError>) -> Validate<Self, Response<Self.TaskRequest, Self.TaskValue>, Self.TaskError, NewValueType, Self.TaskError> {
        return Validate(self, validate)
    }
    
    func catchErrorAsNil() -> Validate<Self, Response<Self.TaskRequest, Self.TaskValue>, Self.TaskError, Self.TaskValue?, Self.TaskError> {
        return Validate(self) { .success((try? $0.get())?.value) }
    }
}

// MARK: - Validate
extension Validate: Taskable where Current: Taskable, ValueType == Response<Current.TaskRequest, Current.TaskValue>, NewErrorType == Current.TaskError, ErrorType == Current.TaskError {
    public typealias TaskRequest = Current.TaskRequest
    public typealias TaskValue = NewValueType
    public typealias TaskError = Error
    
    public func request(_ request: TaskRequest, _ recieve: @escaping ResultHandler<TaskValue, TaskError>) {
        let validate = self.validate
        current.request(request) {
            switch $0 {
            case .success(let value):
                return recieve(validate(.success(.init(request: request, value: value))).mapError { $0 })
            case .failure(let error):
                return recieve(validate(.failure(error)).mapError { $0 })
            }
        }
    }
}
