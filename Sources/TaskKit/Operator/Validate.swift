//
//  Validate.swift
//  TaskKit
//
//  Created by Tadashi.Chiu on 2020/06/30.
//

import Foundation

public class Validate<Current, ValueType, ErrorType: Error, NewValueType, NewErrorType: Error> {
    let current: Current
    let validate: (Result<ValueType, ErrorType>) -> Result<NewValueType, NewErrorType>
    
    init(_ current: Current, _ validate: @escaping (Result<ValueType, ErrorType>) -> Result<NewValueType, NewErrorType>) {
        self.current = current
        self.validate = validate
    }
}
