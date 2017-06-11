//
//  JSONFetcherTests.swift
//  PeekazooTests
//
//  Created by Thomas Sherwood on 11/06/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import XCTest

struct JSONFetcher {

    init(networkAdapter: Any) {

    }

    func fetchJSON(completionHandler: () -> Void) {
        completionHandler()
    }

}

class CapturingJSONHandler {

    private(set) var wasToldLoadFailed = false
    func verify() {
        wasToldLoadFailed = true
    }

}

class JSONFetcherTests: XCTestCase {

    func testFailingToLoadDataTellsHandlerFetchFailed() {
        let capturingJSONHandler = CapturingJSONHandler()
        let failingNetworkAdapter = FailingNetworkAdapter()
        let jsonFetcher = JSONFetcher(networkAdapter: failingNetworkAdapter)
        jsonFetcher.fetchJSON(completionHandler: capturingJSONHandler.verify)

        XCTAssertTrue(capturingJSONHandler.wasToldLoadFailed)
    }

}
