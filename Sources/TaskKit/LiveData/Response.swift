//
//  Response.swift
//  TaskKit
//
//  Created by Tadashi.Chiu on 2020/06/29.
//

import Foundation

public struct Response<Request, Value> {
    let request: Request
    let value: Value
}

public typealias ReponseResult<Req, Value, E: Error> = Response<Req, Result<Value, E>>

public typealias ReponseResultHandler<Req, Value, E: Error> = (ReponseResult<Req, Value, E>) -> Void

public typealias EscapingReponseResultHandler<Req, Value, E: Error> = (@escaping ReponseResultHandler<Req, Value, Error>) -> Void

public typealias ResultHandler<Value, E: Error> = (Result<Value, E>) -> Void

public typealias EscapingResultHandler<Value, E: Error> = (@escaping ResultHandler<Value, Error>) -> Void

public protocol ResultObservable: AnyObject {
    associatedtype ResultObservableValue
    associatedtype ResultObservableError: Error
    func register(_ handler: @escaping ResultHandler<ResultObservableValue, ResultObservableError>) -> ResultObserver<ResultObservableValue, ResultObservableError>.Token
    func unregister(_ observer: ResultObserver<ResultObservableValue, ResultObservableError>)
}

public class ResultObserver<ValueType, ErrorType: Error>: NSObject {
    let handler: ResultHandler<ValueType, ErrorType>
    lazy var id: ObjectIdentifier = ObjectIdentifier(self)
    
    init(_ handler: @escaping ResultHandler<ValueType, ErrorType>) {
        self.handler = handler
    }
}

extension ResultObserver {
    public class Token {
        let observer: ResultObserver
        let unregister: (ResultObserver) -> Void
        
        public init<O: ResultObservable>(_ observer: ResultObserver, _ observable: O) where O.ResultObservableValue == ValueType, O.ResultObservableError == ErrorType {
            self.observer = observer
            self.unregister = { [weak observable] in
                observable?.unregister($0)
            }
        }
        
        deinit {
            unregister(observer)
        }
    }
}
