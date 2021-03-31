//
//  Operationable+Map.swift
//  TaskKit
//
//  Created by Tadashi.Chiu on 2020/06/01.
//

import Foundation

// MARK: - Operationable
public extension Operationable {
    func then<NewValueType>(_ map: @escaping (Self.OperationValue) -> NewValueType) -> Map<Self, Self.OperationValue, NewValueType> {
        return Map(self, map)
    }
}

// MARK: - Map
extension Map: Operationable where Current: Operationable, Current.OperationValue == ValueType {
    public typealias OperationConfigration = Current.OperationConfigration
    public typealias OperationValue = NewValueType
    public typealias OperationError = Error
    
    public func start(with config: OperationConfigration) {
        current.start(with: config)
    }
    
    public func didRecieve(_ didRecieve: @escaping ResultHandler<OperationValue, OperationError>) {
        let map = self.map
        current.didRecieve {
            switch $0 {
            case .success(let value):
                didRecieve(.success(map(value)))
            case .failure(let error):
                didRecieve(.failure(error))
            }
        }
    }
}
