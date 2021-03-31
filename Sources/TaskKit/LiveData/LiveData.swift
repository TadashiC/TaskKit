//
//  LiveData.swift
//  TaskKit
//
//  Created by Tadashi.Chiu on 2020/06/01.
//

import Foundation

public enum LiveStatus {
    case `default`
    case fetching
    case end
    case failed(Error)
    
    public var isFetching: Bool {
        switch self {
        case .fetching: return true
        default: return false
        }
    }
    
    public var isEnded: Bool {
        switch self {
        case .end: return true
        default: return false
        }
    }
    
    public var error: Error? {
        switch self {
        case .failed(let error): return error
        default: return nil
        }
    }
}

public struct LiveDiffer<Value> {
    public let old: Value?
    public let new: Value?
    
    init(_ old: Value? = nil, _ new: Value? = nil) {
        self.old = old
        self.new = new
    }
}

private struct LiveContainer<Value> {
    let status: LiveStatus
    let value: Value?
    let error: Error?

    private init(status: LiveStatus = .default, value: Value? = nil) {
        self.status = status
        self.value = value
        if case let .failed(error) = status {
            self.error = error
        } else {
            self.error = nil
        }
    }

    init() {
        self.status = .default
        self.value = nil
        self.error = nil
    }

    func update(_ status: LiveStatus) -> LiveContainer {
        return LiveContainer(status: status, value: value)
    }

    func update(_ value: Value) -> LiveContainer {
        return LiveContainer(status: status, value: value)
    }
}

public class LiveData<Parameter, Value> {
    
    private typealias Container = LiveContainer<(Parameter, Value)>
    public typealias Status = LiveStatus
    public typealias Differ = LiveDiffer<Value>
    
    private var container: Container = Container() {
        didSet {
            switch container.status {
            case .default, .end:
                let diff = Differ(oldValue.value?.1, container.value?.1)
                observers.values.forEach { $0.handler(.success(diff)) }
            case let .failed(error):
                observers.values.forEach { $0.handler(.failure(error)) }
            case .fetching: ()
            }
        }
    }
    
    public var value: Value? { return container.value?.1 ?? defaultValue }
    public var parameter: Parameter? { return container.value?.0 }
    public var status: Status { return container.status }
    
    private let defaultValue: Value?
    private var observers: [ObjectIdentifier: ResultObserver<Differ, Error>] = [:]
    
    private var request: (Parameter, @escaping (Response<Parameter, Result<(Value, Status), Error>>) -> Void) -> Void = { _, _ in }
    
    private lazy var didRecieve: (Response<Parameter, Result<(Value, Status), Error>>) -> Void = { [weak self] in
        guard let `this` = self else { return }
        switch $0.value {
        case .success(let value):
            this.container = this.container.update(($0.request, value.0)).update(value.1)
        case .failure(let error):
            this.container = this.container.update(.failed(error))
        }
    }
    
    public init(value: Value? = nil, _ request: @escaping (Parameter, @escaping (Response<Parameter, Result<(Value, Status), Error>>) -> Void) -> Void) {
        self.defaultValue = value
        self.request = request
    }
    
    public func refresh(with parameter: Parameter) {
        container = container.update(.fetching)
        request(parameter, didRecieve)
    }
}

extension LiveData where Value: Pageable {
    public func loadMore(with parameter: Parameter) {
        container = container.update(.fetching)
        let current: Value? = {
            guard let response = container.value else { return nil }
            return response.1
        }()
        request(parameter) { [weak self] in
            guard let `this` = self else { return }
            let response = $0
            switch response.value {
            case .failure:
                this.didRecieve(response)
            case .success(let result):
                let newValue = current?.addNextPage(result.0) ?? result.0
                let status = result.0.isEnd ? Status.end : Status.default
                this.didRecieve(.init(request: parameter, value: .success((newValue, status))))
            }
        }
    }
}

extension LiveData: ResultObservable {
    public typealias ResultObservableError = Error
    public typealias ResultObservableValue = Differ
    
    public func register(_ handler: @escaping ResultHandler<ResultObservableValue, ResultObservableError>) -> ResultObserver<ResultObservableValue, ResultObservableError>.Token {
        let obs = ResultObserver(handler)
        let id = obs.id
        observers[id] = obs
        return .init(obs, self)
    }
    
    public func unregister(_ observer: ResultObserver<ResultObservableValue, ResultObservableError>) {
        let id = observer.id
        observers[id] = nil
    }
}
