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

}
