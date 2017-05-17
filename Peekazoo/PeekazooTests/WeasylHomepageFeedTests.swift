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
        let blockedNetworkAdapter = BlockingNetworkAdapter(adapter: FailingNetworkAdapter())
        feed.loadFeed(networkAdapter: blockedNetworkAdapter, delegate: capturingHomepageFeedDelegate)

        XCTAssertFalse(capturingHomepageFeedDelegate.wasNotifiedFeedDidFailToLoad)
    }

    func testWhenLoadingValidFeedDataTheDelegateIsToldTheFeedLoaded() {
        let successfulNetworkAdapter = SuccessfulNetworkAdapter(contentsOfJSONFile: "ValidWeasylHomepageResponse")
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        feed.loadFeed(networkAdapter: successfulNetworkAdapter, delegate: capturingHomepageFeedDelegate)

        XCTAssertTrue(capturingHomepageFeedDelegate.wasNotifiedDidFinishLoading)
    }

    func testTheDelegateIsNotToldAboutFeedLoadsUntilNetworkHandlerIsInvokedWithData() {
        let blockedNetworkAdapter = BlockingNetworkAdapter(adapter: SuccessfulNetworkAdapter(contentsOfJSONFile: "ValidWeasylHomepageResponse"))
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        feed.loadFeed(networkAdapter: blockedNetworkAdapter, delegate: capturingHomepageFeedDelegate)

        XCTAssertFalse(capturingHomepageFeedDelegate.wasNotifiedDidFinishLoading)
    }

    func testTheDelegateIsNotToldAboutFeedLoadsWhenNetworkErrors() {
        let successfulNetworkAdapter = FailingNetworkAdapter()
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        feed.loadFeed(networkAdapter: successfulNetworkAdapter, delegate: capturingHomepageFeedDelegate)

        XCTAssertFalse(capturingHomepageFeedDelegate.wasNotifiedDidFinishLoading)
    }

    func testTheDelegateIsNotToldAboutFeedErrorsWhenNetworkSucceeds() {
        let blockedNetworkAdapter = SuccessfulNetworkAdapter(contentsOfJSONFile: "ValidWeasylHomepageResponse")
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        feed.loadFeed(networkAdapter: blockedNetworkAdapter, delegate: capturingHomepageFeedDelegate)

        XCTAssertFalse(capturingHomepageFeedDelegate.wasNotifiedFeedDidFailToLoad)
    }

    func testNetworkRespondsWithInvalidJSONNotifiesDelegateAboutError() {
        let invalidJSONAdapter = SuccessfulNetworkAdapter(contentsOfJSONFile: "MalformedWeasylHomepageResponse")
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        feed.loadFeed(networkAdapter: invalidJSONAdapter, delegate: capturingHomepageFeedDelegate)

        XCTAssertTrue(capturingHomepageFeedDelegate.wasNotifiedFeedDidFailToLoad)
    }

    func testNetworkRespondsWithInvalidJSONDoesNotNotifyDelegateLoadWasSuccessful() {
        let invalidJSONAdapter = SuccessfulNetworkAdapter(contentsOfJSONFile: "MalformedWeasylHomepageResponse")
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        feed.loadFeed(networkAdapter: invalidJSONAdapter, delegate: capturingHomepageFeedDelegate)

        XCTAssertFalse(capturingHomepageFeedDelegate.wasNotifiedDidFinishLoading)
    }

    func testNetworkRespondsWithJSONThatDoesNotContainExpectedTopLevelStructureTellsDelegateLoadFailed() {
        let unexpectedStructure = ["key": "value"]
        let json = try! JSONSerialization.data(withJSONObject: unexpectedStructure, options: .prettyPrinted)
        let unexpectedJSONAdapter = SuccessfulNetworkAdapter(data: json)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        feed.loadFeed(networkAdapter: unexpectedJSONAdapter, delegate: capturingHomepageFeedDelegate)

        XCTAssertTrue(capturingHomepageFeedDelegate.wasNotifiedFeedDidFailToLoad)
    }

    func testParsingValidJSONProvidesFirstItemWithExpectedTitle() {
        let titleForFirstItemInJSON = ":CO: ChaiFennec"
        let validHomepageAdapter = SuccessfulNetworkAdapter(contentsOfJSONFile: "ValidWeasylHomepageResponse")
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        feed.loadFeed(networkAdapter: validHomepageAdapter, delegate: capturingHomepageFeedDelegate)

        XCTAssertEqual(titleForFirstItemInJSON, capturingHomepageFeedDelegate.capturedResults?.first?.title)
    }

    func testParsingValidJSONProvidesSecondItemWithExpectedTitle() {
        let titleForSecondItemInJSON = "[C] Azri Simple Icon"
        let validHomepageAdapter = SuccessfulNetworkAdapter(contentsOfJSONFile: "ValidWeasylHomepageResponse")
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        feed.loadFeed(networkAdapter: validHomepageAdapter, delegate: capturingHomepageFeedDelegate)

        guard let results = capturingHomepageFeedDelegate.capturedResults, results.count > 1 else {
            XCTFail()
            return
        }

        XCTAssertEqual(titleForSecondItemInJSON, results[1].title)
    }

    func testParsingValidJSONProvidesFirstItemWithExpectedContentIdentifier() {
        let contentIdentifierForFirstItemInJSON = "1489775"
        let validHomepageAdapter = SuccessfulNetworkAdapter(contentsOfJSONFile: "ValidWeasylHomepageResponse")
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        feed.loadFeed(networkAdapter: validHomepageAdapter, delegate: capturingHomepageFeedDelegate)

        XCTAssertEqual(contentIdentifierForFirstItemInJSON, capturingHomepageFeedDelegate.capturedResults?.first?.contentIdentifier)
    }

}
