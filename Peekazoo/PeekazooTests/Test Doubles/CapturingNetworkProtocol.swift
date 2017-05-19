//
//  CapturingNetworkProtocol.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 17/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation
import XCTest

class CapturingNetworkProtocol: URLProtocol {

    private static var loadExpectations = [URL: XCTestExpectation]()
    private static var responseData = [URL: Data]()
    private static var responseErrors = [URL: Error]()

    class func registerLoadExpectation(_ expectation: XCTestExpectation, for url: URL) {
        loadExpectations[url] = expectation
    }

    class func registerResponseData(_ data: Data, for url: URL) {
        responseData[url] = data
    }

    class func registerResponseError(_ error: Error, for url: URL) {
        responseErrors[url] = error
    }

    private class func fulfillLoadExpectation(for request: URLRequest) {
        guard let url = request.url else { return }
        CapturingNetworkProtocol.loadExpectations[url]?.fulfill()
    }

    class func setUp() {
        URLProtocol.registerClass(CapturingNetworkProtocol.self)
    }

    class func tearDown() {
        URLProtocol.unregisterClass(CapturingNetworkProtocol.self)
        loadExpectations.removeAll()
        responseData.removeAll()
        responseErrors.removeAll()
    }

    open override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    open override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    open override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return true
    }

    override func startLoading() {
        if let data = CapturingNetworkProtocol.responseData[request.url!] {
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        }

        if let error = CapturingNetworkProtocol.responseErrors[request.url!] {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {

    }

    override init(request: URLRequest, cachedResponse: CachedURLResponse?, client: URLProtocolClient?) {
        super.init(request: request, cachedResponse: cachedResponse, client: client)
        CapturingNetworkProtocol.fulfillLoadExpectation(for: request)
    }

}
