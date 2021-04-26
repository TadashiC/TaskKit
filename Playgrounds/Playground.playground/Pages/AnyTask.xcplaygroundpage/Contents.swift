/*:
 [Previous](@previous)
 
 ---

 You might also build you own Task by **AnyTask**
 */

import Foundation
import TaskKit

let input: Int = 1

let increase = AnyTask<Int, Int, Never> {
    $1(.success($0+1))
}

increase.request(input) {
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
