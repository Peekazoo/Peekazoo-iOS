//
//  WeasylHomepageFeedTests.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 16/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo
import XCTest

class WeasylHomepageFeedTests: XCTestCase {

    func testWhenToldToLoadTheHomepageURLIsRequested() {
        let expectedURL = URL(string: "https://www.weasyl.com/api/submissions/frontpage")!
        let capturingNetworkAdapter = CapturingNetworkAdapter()
        let feed = WeasylHomepageFeed()
        feed.loadFeed(networkAdapter: capturingNetworkAdapter, delegate: DummyHomepageFeedDelegate())

        XCTAssertEqual(expectedURL, capturingNetworkAdapter.requestedURL)
    }

    func testTheDelegateIsToldTheFeedFailedToLoadWhenNetworkEncounteredError() {
        let feed = WeasylHomepageFeed()
        let failingNetworkAdapter = FailingNetworkAdapter()
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        feed.loadFeed(networkAdapter: failingNetworkAdapter, delegate: capturingHomepageFeedDelegate)

        XCTAssertTrue(capturingHomepageFeedDelegate.wasNotifiedFeedDidFailToLoad)
    }

}
