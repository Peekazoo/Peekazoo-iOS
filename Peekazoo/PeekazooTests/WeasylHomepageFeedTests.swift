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

    var feed: WeasylHomepageFeed!

    override func setUp() {
        super.setUp()

        feed = WeasylHomepageFeed()
    }

    func testWhenToldToLoadTheHomepageURLIsRequested() {
        let expectedURL = URL(string: "https://www.weasyl.com/api/submissions/frontpage")!
        let capturingNetworkAdapter = CapturingNetworkAdapter()
        feed.loadFeed(networkAdapter: capturingNetworkAdapter, delegate: DummyHomepageFeedDelegate())

        XCTAssertEqual(expectedURL, capturingNetworkAdapter.requestedURL)
    }

    func testTheDelegateIsToldTheFeedFailedToLoadWhenNetworkEncounteredError() {
        let failingNetworkAdapter = FailingNetworkAdapter()
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        feed.loadFeed(networkAdapter: failingNetworkAdapter, delegate: capturingHomepageFeedDelegate)

        XCTAssertTrue(capturingHomepageFeedDelegate.wasNotifiedFeedDidFailToLoad)
    }

    func testTheDelegateIsNotToldAboutFeedFailuresUntilNetworkHandlerIsInvokedWithError() {
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        feed.loadFeed(networkAdapter: DummyNetworkAdapter(), delegate: capturingHomepageFeedDelegate)

        XCTAssertFalse(capturingHomepageFeedDelegate.wasNotifiedFeedDidFailToLoad)
    }

    func testWhenLoadingValidFeedDataTheDelegateIsToldTheFeedLoaded() {
        let filename = "ValidWeasylHomepageResponse"
        let url = Bundle(for: type(of: self)).url(forResource: filename, withExtension: "json")!
        let data = try? Data(contentsOf: url)
        let successfulNetworkAdapter = SuccessfulNetworkAdapter(data: data)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        feed.loadFeed(networkAdapter: successfulNetworkAdapter, delegate: capturingHomepageFeedDelegate)

        XCTAssertTrue(capturingHomepageFeedDelegate.wasNotifiedDidFinishLoading)

    }

}
