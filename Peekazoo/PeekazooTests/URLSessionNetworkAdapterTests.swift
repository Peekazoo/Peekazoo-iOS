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
        let matcher = MockNetworkDataMatcher(expectedData: inputData, expectation: matchingExpectation)
        adapter.get(url, completionHandler: matcher.verify)

        waitForExpectations(timeout: 0.1)
    }

    func testUnsuccessfulNetworkLoadsProvideErrorToCompletionHandler() {
        let url = URL(string: "https://it.doesnt.matter")!
        let error = NSError(domain: "Some domain", code: 0, userInfo: [:])
        CapturingNetworkProtocol.registerResponseError(error, for: url)
        let matchingExpectation = expectation(description: "Error should be provided to completion handler")
        let matcher = MockNetworkErrorMatcher(expectedError: error, expectation: matchingExpectation)
        adapter.get(url, completionHandler: matcher.verify)

        waitForExpectations(timeout: 0.1)
    }

}
