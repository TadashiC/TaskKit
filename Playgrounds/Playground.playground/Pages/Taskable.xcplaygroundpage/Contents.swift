/*:
 [Previous](@previous)
 
 ---

 Implement **Taskable** to build you own Task
 */

import Foundation
import TaskKit

struct IncreaseTask: Taskable {
    typealias TaskRequest = Int
    typealias TaskValue = Int
    typealias TaskError = Never
    
    func request(_ request: Int,
                 _ recieve: @escaping ResultHandler<Int, TaskError>) {
        recieve(.success(request + 1))
    }
}

let input: Int = 1

let increase = IncreaseTask()

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
