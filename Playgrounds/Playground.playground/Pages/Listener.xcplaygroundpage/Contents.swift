//: [Previous](@previous)

import Foundation
import TaskKit

class SomeObject {
    let listener = Listener<SomeObject>()
    var valueA: Int = 0 {
        didSet {
            listener.notify(keyPath: \SomeObject.valueA, value: valueA)
        }
    }
    private var _valueB: String = "" {
        didSet {
            listener.notify(keyPath: \SomeObject.valueB, value: valueB)
        }
    }
    var valueB: String {
        set {
            _valueB = newValue
        }
        get {
            _valueB
        }
    }
    var valueC = OtherObject()
    
    func updateValueC() {
        valueC.value = true
        listener.notify(keyPath: \SomeObject.valueC, value: valueC)
    }
}

class OtherObject {
    var value: Bool = false
}

//: [Next](@next)
