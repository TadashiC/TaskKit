//
//  LiveData+Taskable.swift
//  TaskKit
//
//  Created by Tadashi.Chiu on 2020/07/02.
//

import Foundation

extension LiveData {
    public convenience init<T: Taskable>(value: Value? = nil, _ task: T) where T.TaskRequest == Parameter, T.TaskValue == Value {
        self.init(value: value) { parameter, callback in
            task.request(parameter) {
                callback(.init(request: parameter, value: $0.map { ($0, Status.end) }.mapError { $0 }))
            }
        }
    }
}

extension Taskable {
    func asLiveData(_ initValue: TaskValue? = nil) -> LiveData<TaskRequest, TaskValue> {
        return LiveData(value: initValue, self)
    }
}
