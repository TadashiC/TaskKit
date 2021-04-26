/*:
 [Previous](@previous)
 
 ---

 Use **Then** to series connect two tasks
 */

import Foundation
import TaskKit

let increase = AnyTask<Int, Int, Never> {
    $1(.success($0+1))
}

let toString = AnyTask<Int, String, Never> {
    $1(.success("\($0)"))
}

let input = 1

let task = increase.then { toString }

task.request(input) {
    switch $0 {
    case .success(let value):
        print(value)
    case .failure(let error):
        print(error.localizedDescription)
    }
}

/*:
 [Next](@next)
 
 ---
 
 [Top](Cover)
*/
