/*:
 [Previous](@previous)
 
 ---

 Use **Pair** to parallel connect two tasks
 */

import Foundation
import TaskKit

let increase = AnyTask<Int, Int, Never> {
    $1(.success($0 + 1))
}

let decrease = AnyTask<Int, Int, Never> {
    $1(.success($0 - 1))
}

let input = (1, 1)

let task = increase.pair { decrease }

task.request((input)) {
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
