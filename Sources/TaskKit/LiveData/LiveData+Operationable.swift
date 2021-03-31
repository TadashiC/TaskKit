//
//  LiveData+Operationable.swift
//  TaskKit
//
//  Created by Tadashi.Chiu on 2020/07/02.
//

import Foundation

extension LiveData {
    public convenience init<O: Operationable>(value: Value? = nil, _ operation: O) where O.OperationValue == Value, O.OperationConfigration == Parameter {
        self.init(value: value) { parameter, callback in
            operation.didRecieve {
                callback(.init(request: parameter, value: $0.map { ($0, Status.default) }.mapError { $0 }))
            }
            operation.start(with: parameter)
        }
    }
}



extension Operationable {
    func asLiveData(_ initValue: OperationValue? = nil) -> LiveData<OperationConfigration, OperationValue> {
        return LiveData(value: initValue, self)
    }
}
