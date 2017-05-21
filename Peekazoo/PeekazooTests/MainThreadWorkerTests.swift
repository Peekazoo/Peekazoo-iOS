//
//  MainThreadWorkerTests.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 21/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo
import XCTest

struct MainThreadWorker: Worker {

    func execute(_ work: @escaping () -> Void) {
        DispatchQueue.main.async(execute: work)

        if Thread.current.isMainThread {
            work()
        }
    }

}

class MainThreadWorkerTests: XCTestCase {

    func testShouldInvokeTheWorkOnTheMainThreadWhenInvokingFromSecondaryThread() {
        let worker = MainThreadWorker()
        let mainThreadExpectation = expectation(description: "Should be ran on the main thread")
        DispatchQueue.global(qos: .userInteractive).async {
            worker.execute {
                if Thread.current.isMainThread {
                    mainThreadExpectation.fulfill()
                }
            }
        }

        waitForExpectations(timeout: 0.1)
    }

    func testShouldInvokeTheWorkImmediatleyWhenInvokingFromMainThead() {
        let worker = MainThreadWorker()
        var ran = false
        worker.execute { ran = true }

        XCTAssertTrue(ran)
    }

    func testShouldNotInvokeTheWorkImmediatleyWhenInvokingFromSecondaryThread() {
        let worker = MainThreadWorker()
        let notRanUsingSecondaryThreadExpectation = expectation(description: "Should not run on secondary thread")
        DispatchQueue.global(qos: .userInteractive).async {
            var ran = false
            worker.execute { ran = true }

            if ran == false {
                notRanUsingSecondaryThreadExpectation.fulfill()
            }
        }

        waitForExpectations(timeout: 0.1)
    }

}
