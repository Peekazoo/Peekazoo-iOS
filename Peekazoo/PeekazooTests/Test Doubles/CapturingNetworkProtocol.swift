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

    class func registerLoadExpectation(_ expectation: XCTestExpectation, for url: URL) {
        loadExpectations[url] = expectation
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

    }

    override func stopLoading() {

    }

    override init(request: URLRequest, cachedResponse: CachedURLResponse?, client: URLProtocolClient?) {
        super.init(request: request, cachedResponse: cachedResponse, client: client)
        CapturingNetworkProtocol.fulfillLoadExpectation(for: request)
    }

}
