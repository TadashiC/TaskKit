//
//  File.swift
//  
//
//  Created by Tadashi Chiu on 2021/04/26.
//

import Foundation

class Listener {
    
    private var listerns: [Handler] = []
    
    func listen<E, U>(keyPath: KeyPath<E, U>, didUpdate: @escaping (U) -> Void) -> Token {
        let handler = Handler(keyPath: keyPath, didUpdate)
        listerns.append(handler)
        return Token(self, handler)
    }
    
    func unlisten(_ token: Token) {
        listerns = listerns.filter { $0.id != token.handler.id }
    }
    
    func unlisten<E, U>(_ keyPath: KeyPath<E, U>) {
        listerns = listerns.filter { $0.keyPath != keyPath }
    }
    
    func notify<E, U>(keyPath: KeyPath<E, U>, value: U) {
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
    private weak var listener: Listener?
    
    fileprivate init(_ listener: Listener, _ handler: Handler) {
        self.listener = listener
        self.handler = handler
    }
    
    func invalid() {
        listener?.unlisten(self)
    }
    
    deinit {
        invalid()
    }
}
