//
//  JSONFetcherTests.swift
//  PeekazooTests
//
//  Created by Thomas Sherwood on 11/06/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import XCTest
import Peekazoo

struct JSONFetcher {

    enum Result {
        case success
        case failure
    }

    private let networkAdapter: NetworkAdapter

    init(networkAdapter: NetworkAdapter) {
        self.networkAdapter = networkAdapter
    }

    func fetchJSON(representing: Any.Type, completionHandler: @escaping (Result) -> Void) {
        let url = URL(string: "https://www.bbc.co.uk")!
        networkAdapter.get(url) { (data, _) in
            guard data != nil else {
                completionHandler(.failure)
                return
            }

            completionHandler(.success)
        }
    }

}

class CapturingJSONHandler {

    private(set) var wasToldLoadFailed = false
    private(set) var wasToldLoadSucceeded = false
    func verify(_ result: JSONFetcher.Result) {
        switch result {
        case .success:
            wasToldLoadSucceeded = true

        case .failure:
            wasToldLoadFailed = true
        }
    }

}

struct EmptyJSONObject: Decodable {

}

class JSONFetcherTests: XCTestCase {

    func testFailingToLoadDataTellsHandlerFetchFailed() {
        let capturingJSONHandler = CapturingJSONHandler()
        let failingNetworkAdapter = FailingNetworkAdapter()
        let jsonFetcher = JSONFetcher(networkAdapter: failingNetworkAdapter)
        jsonFetcher.fetchJSON(representing: EmptyJSONObject.self, completionHandler: capturingJSONHandler.verify)

        XCTAssertTrue(capturingJSONHandler.wasToldLoadFailed)
    }

    func testSuccessfulNetworkLoadWithHappyParsingPathTellsHandlerFetchSucceeded() {
        let capturingJSONHandler = CapturingJSONHandler()
        let emptyJSONObjectData = "{}".data(using: .utf8)
        let successfulNetworkAdapter = SuccessfulNetworkAdapter(data: emptyJSONObjectData)
        let jsonFetcher = JSONFetcher(networkAdapter: successfulNetworkAdapter)
        jsonFetcher.fetchJSON(representing: EmptyJSONObject.self, completionHandler: capturingJSONHandler.verify)

        XCTAssertTrue(capturingJSONHandler.wasToldLoadSucceeded)
    }

    func testFailingToLoadDataDoesNotTellHandlerFetchSucceeded() {
        let capturingJSONHandler = CapturingJSONHandler()
        let failingNetworkAdapter = FailingNetworkAdapter()
        let jsonFetcher = JSONFetcher(networkAdapter: failingNetworkAdapter)
        jsonFetcher.fetchJSON(representing: EmptyJSONObject.self, completionHandler: capturingJSONHandler.verify)

        XCTAssertFalse(capturingJSONHandler.wasToldLoadSucceeded)
    }

}
