//
//  MainThreadWorkerTests.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 21/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Peekazoo
import XCTest

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

    func testShouldNotInvokeTheWorkTwiceWhenInvokedFromTheMainThread() {
        let worker = MainThreadWorker()
        let notInvokedTwiceExpectation = expectation(description: "Should not run work multiple times on main thread")
        notInvokedTwiceExpectation.isInverted = true
        var runCount = 0
        worker.execute {
            runCount += 1

            if runCount == 2 {
                notInvokedTwiceExpectation.fulfill()
            }
        }

        waitForExpectations(timeout: 0.1)
    }

}
