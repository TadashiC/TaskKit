//
//  Taskable+Map.swift
//  TaskKit
//
//  Created by Tadashi.Chiu on 2020/06/01.
//

import Foundation

// MARK: - Taskable
public extension Taskable {
    func map<NewValueType>(_ map: @escaping (Response<Self.TaskRequest, Self.TaskValue>) -> NewValueType) -> Map<Self, Response<Self.TaskRequest, Self.TaskValue>, NewValueType> {
        return Map(self, map)
    }
}

// MARK: - Map
extension Map: Taskable where Current: Taskable, ValueType == Response<Current.TaskRequest, Current.TaskValue> {
    public typealias TaskRequest = Current.TaskRequest
    public typealias TaskValue = NewValueType
    public typealias TaskError = Error
    
    public func request(_ request: TaskRequest, _ recieve: @escaping ResultHandler<TaskValue, TaskError>) {
        let map = self.map
        current.request(request) {
            switch $0 {
            case .success(let value):
                return recieve(.success(map(.init(request: request, value: value))))
            case .failure(let error):
                return recieve(.failure(error))
            }
        }
    }
}
