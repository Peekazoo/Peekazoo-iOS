//
//  WeasylHomepageFeedTests.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 16/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo
import XCTest

class CapturingNetworkAdapter: NetworkAdapter {

    private(set) var requestedURL: URL?
    func get(_ url: URL) {
        requestedURL = url
    }

}

class WeasylHomepageFeedTests: XCTestCase {

    func testWhenToldToLoadTheHomepageURLIsRequested() {
        let expectedURL = URL(string: "https://www.weasyl.com/api/submissions/frontpage")!
        let capturingNetworkAdapter = CapturingNetworkAdapter()
        let feed = WeasylHomepageFeed()
        feed.loadFeed(networkAdapter: capturingNetworkAdapter, delegate: DummyHomepageFeedDelegate())

        XCTAssertEqual(expectedURL, capturingNetworkAdapter.requestedURL)
    }

}
