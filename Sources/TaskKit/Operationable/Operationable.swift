//
//  Operationable.swift
//  TaskKit
//
//  Created by Tadashi.Chiu on 2020/06/01.
//

import Foundation

/// Operationable
public protocol Operationable: AnyObject {
    associatedtype OperationConfigration
    associatedtype OperationValue
    associatedtype OperationError: Error
    
    func didRecieve(_ didRecieve: @escaping ResultHandler<OperationValue, OperationError>)
    
    func start(with config: OperationConfigration)
}

extension Operationable {
    public func asOperation() -> AnyOperation<OperationConfigration, OperationValue> {
        return AnyOperation(self)
    }
}

extension AnyOperation {
    convenience init<O: Operationable>(_ operation: O) where O.OperationValue == Out, O.OperationConfigration == In {
        self.init { config, callbask in
            operation.didRecieve {
                callbask($0.mapError { $0 })
            }
            operation.start(with: config)
        }
    }
}
