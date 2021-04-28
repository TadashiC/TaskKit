//
//  File.swift
//  
//
//  Created by Tadashi Chiu on 2021/04/26.
//

import Foundation

class Listener<E> {
    private let queue = DispatchQueue(label: "taskkit.listener")
    private var listerns: [Handler] = []
    
    func listen<U>(keyPath: KeyPath<E, U>, didUpdate: @escaping (U) -> Void) -> Token {
        let handler = Handler(keyPath: keyPath, didUpdate)
        listerns.append(handler)
        return Token(self, handler)
    }
    
    func unlisten(_ token: Token) {
        listerns = listerns.filter { $0.id != token.handler.id }
    }
    
    func unlisten<U>(_ keyPath: KeyPath<E, U>) {
        listerns = listerns.filter { $0.keyPath != keyPath }
    }
    
    func notify<U>(keyPath: KeyPath<E, U>, value: U) {
        for handler in listerns where handler.keyPath == keyPath {
            handler.handler(value)
        }
    }
}

fileprivate class Handler {
    lazy var id: ObjectIdentifier = ObjectIdentifier(self)
    let keyPath: AnyKeyPath
    let handler: (Any) -> Void
    init<T>(keyPath: AnyKeyPath,
            _ handler: @escaping (T) -> Void) {
        self.keyPath = keyPath
        self.handler = {
            guard let value = $0 as? T else { return }
            handler(value)
        }
    }
}

class Token {
    fileprivate let handler: Handler
    private var invalidHandler: (Token) -> Void = { _ in }
    
    fileprivate init<T>(_ listener: Listener<T>, _ handler: Handler) {
        self.invalidHandler = { [weak listener] in
            
            listener?.unlisten($0)
        }
        self.handler = handler
    }
    
    func invalid() {
        invalidHandler(self)
    }
    
    deinit {
        invalid()
    }
}
