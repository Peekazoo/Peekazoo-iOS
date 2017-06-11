//
//  WeasylHomepageAdapterTests.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 18/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Peekazoo
import XCTest

class WeasylHomepageAdapterTests: XCTestCase {

    func testFetchingHomepageShouldTellTheServiceToPerformFetch() {
        let capturingWeasylAPI = CapturingWeasylAPI()
        let adapter = WeasylHomepageAdapter(api: capturingWeasylAPI)
        adapter.loadFeed(delegate: DummyHomepageFeedDelegate())

        XCTAssertTrue(capturingWeasylAPI.didLoadHomepage)
    }

    func testSuccessfullyFetchingWeasylItemAdaptsItemIntoPeekazooDomainObjectWithContentIdentifier() {
        let item = StubWeasylSubmission(submitID: "ID")
        let successfulWeasylAPI = SuccessfulWeasylAPI(items: [item])
        let adapter = WeasylHomepageAdapter(api: successfulWeasylAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertEqual(item.submitID, capturingHomepageFeedDelegate.result(at: 0)?.contentIdentifier)
    }

    func testSuccessfullyFetchingWeasylItemAdaptsItemIntoPeekazooDomainObjectWithTitle() {
        let item = StubWeasylSubmission(title: "Title")
        let successfulWeasylAPI = SuccessfulWeasylAPI(items: [item])
        let adapter = WeasylHomepageAdapter(api: successfulWeasylAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertEqual(item.title, capturingHomepageFeedDelegate.result(at: 0)?.title)
    }

    func testFailingToFetchWeasylItemTellsDelegateLoadFailed() {
        let failingWeasylAPI = FailingWeasylAPI()
        let adapter = WeasylHomepageAdapter(api: failingWeasylAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertTrue(capturingHomepageFeedDelegate.wasNotifiedFeedDidFailToLoad)
    }

    func testSuccessfullyFetchingWeasylItemDoesNotNotifyDelegateOfLoadFailure() {
        let item = StubWeasylSubmission()
        let successfulWeasylAPI = SuccessfulWeasylAPI(items: [item])
        let adapter = WeasylHomepageAdapter(api: successfulWeasylAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertFalse(capturingHomepageFeedDelegate.wasNotifiedFeedDidFailToLoad)
    }

    func testSuccessfullyFetchingMultipleWeasylItemsAdaptsSecondItemTitle() {
        let firstItem = StubWeasylSubmission(title: "Title")
        let secondItem = StubWeasylSubmission(title: "Another Title")
        let successfulWeasylAPI = SuccessfulWeasylAPI(items: [firstItem, secondItem])
        let adapter = WeasylHomepageAdapter(api: successfulWeasylAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertEqual(secondItem.title, capturingHomepageFeedDelegate.result(at: 1)?.title)
    }

    func testSuccessfullyFetchingItemAdaptsPostedAtDate() {
        let postedAt = Date(timeIntervalSinceNow: -7200)
        let item = StubWeasylSubmission(postedAt: postedAt)
        let successfulWeasylAPI = SuccessfulWeasylAPI(items: [item])
        let adapter = WeasylHomepageAdapter(api: successfulWeasylAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertEqual(postedAt, capturingHomepageFeedDelegate.capturedResults?.first?.creationDate)
    }

}
