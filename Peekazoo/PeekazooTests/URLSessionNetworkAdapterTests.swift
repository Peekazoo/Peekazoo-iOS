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

    func testSuccessfulNetworkLoadsProvideDataToCompletionHandler() {
        let url = URL(string: "https://it.doesnt.matter")!
        let inputData = "{ \"key\": \"Some JSON\" }".data(using: .utf8)!
        CapturingNetworkProtocol.registerResponseData(inputData, for: url)
        let matchingExpectation = expectation(description: "Data should be provided to completion handler")
        adapter.get(url) { data, _ in
            if data == inputData {
                matchingExpectation.fulfill()
            }
        }

        waitForExpectations(timeout: 0.1)
    }

    func testUnsuccessfulNetworkLoadsProvideErrorToCompletionHandler() {
        let url = URL(string: "https://it.doesnt.matter")!
        let expectedError = NSError(domain: "Some domain", code: 0, userInfo: [:])
        CapturingNetworkProtocol.registerResponseError(expectedError, for: url)
        let matchingExpectation = expectation(description: "Error should be provided to completion handler")
        adapter.get(url) { _, error in
            if let error = error, error._code == expectedError.code, error._domain == expectedError.domain {
                matchingExpectation.fulfill()
            }
        }

        waitForExpectations(timeout: 0.1)
    }

}
