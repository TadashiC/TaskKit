//
//  Operationable+Then.swift
//  TaskKit
//
//  Created by Tadashi.Chiu on 2020/06/30.
//

import Foundation

// MARK: - Operationable
public extension Operationable {
    func then<Other: Taskable>(_ other: Other) -> Then<Self, Other> where Self.OperationValue == Other.TaskRequest {
        return Then(self, other)
    }
    
    func then<Other: Taskable>(_ other: () -> Other) -> Then<Self, Other> where Self.OperationValue == Other.TaskRequest {
        return Then(self, other())
    }
}

// MARK: - Then
extension Then: Operationable where Current: Operationable, Other: Taskable, Current.OperationValue == Other.TaskRequest {
    public typealias OperationConfigration = Current.OperationConfigration
    public typealias OperationValue = Other.TaskValue
    public typealias OperationError = Error
    
    public func start(with config: OperationConfigration) {
        current.start(with: config)
    }
    
    public func didRecieve(_ didRecieve: @escaping ResultHandler<OperationValue, OperationError>) {
        let other = self.other
        current.didRecieve {
            switch $0 {
            case .success(let value):
                other.request(value) {
                    switch $0 {
                    case .success(let value):
                        didRecieve(.success(value))
                    case .failure(let error):
                        didRecieve(.failure(error))
                    }
                }
            case .failure(let error):
                didRecieve(.failure(error))
            }
        }
    }
}
