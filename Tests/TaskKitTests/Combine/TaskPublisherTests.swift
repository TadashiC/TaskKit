//
//  TaskPublisherTests.swift
//  
//
//  Created by Tadashi.Chiu on 2020/07/13.
//

import XCTest
@testable import TaskKit
import Combine

class TaskPublisherTests: XCTestCase {

    var task1: AnyTask<Bool, Int, Error>!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        task1 = AnyTask {
            switch $0 {
            case true:
                $1(.success(1))
            case false:
                $1(.failure(NSError()))
            }
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
extension TaskPublisherTests {
    func testSuccess() {
        let successExpectation = self.expectation(description: "failure")
        task1.request(for: true).sink(receiveCompletion: {
            switch $0 {
            case .failure: XCTFail()
            case .finished: successExpectation.fulfill()
            }
        }) {
            XCTAssertEqual($0, 1)
        }
        self.wait(for: [successExpectation], timeout: 5)
    }
    
    func testFailure() {
        let failureExpectation = self.expectation(description: "failure")
        task1.request(for: false).sink(receiveCompletion: {
            switch $0 {
            case .failure: failureExpectation.fulfill()
            case .finished: XCTFail()
            }
        }) { _ in
            XCTFail()
        }
        self.wait(for: [failureExpectation], timeout: 5)
    }
    
    func testSubject() {
    }
}
