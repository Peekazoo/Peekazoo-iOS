//
//  URLSessionNetworkAdapterTests.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 17/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo
import XCTest

class URLSessionNetworkAdapterTests: XCTestCase {

    var adapter: URLSessionNetworkAdapter!

    override func setUp() {
        super.setUp()

        CapturingNetworkProtocol.setUp()
        adapter = URLSessionNetworkAdapter()
    }

    override func tearDown() {
        super.tearDown()
        CapturingNetworkProtocol.tearDown()
    }

    func testGettingURLWillPerformTaskWithURL() {
        let url = URL(string: "https://it.doesnt.matter")!
        let requestBeganExpectation = expectation(description: "Request should be loaded")
        CapturingNetworkProtocol.registerLoadExpectation(requestBeganExpectation, for: url)
        adapter.get(url, completionHandler: { _, _ in })

        waitForExpectations(timeout: 0.1)
    }

}
