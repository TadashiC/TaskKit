//
//  AnyService.swift
//  TaskKit
//
//  Created by Tadashi.Chiu on 2020/06/01.
//

import Foundation

public class AnyOperation<In, Out>: Operationable {
    public typealias OperationConfigration = In
    public typealias OperationValue = Out
    public typealias OperationError = Error
    
    // MARK: Properties
    private var operation: (In, @escaping ResultHandler<Out, Error>) -> Void = { _, _ in }
    
    private var didRecieve: ResultHandler<Out, Error> = { _ in }
    
    
    // MARK: Initialization
    init(_ operation: @escaping (In, @escaping ResultHandler<Out, Error>) -> Void) {
        self.operation = operation
    }
    
    // MARK: Operationable
    public func start(with config: OperationConfigration) {
        self.operation(config, didRecieve)
    }
    
    public func didRecieve(_ didRecieve: @escaping ResultHandler<OperationValue, OperationError>) {
        self.didRecieve = didRecieve
    }
}
