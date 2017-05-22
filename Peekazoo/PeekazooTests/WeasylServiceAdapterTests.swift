//
//  WeasylAPIAdapterTests.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 18/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Peekazoo
import XCTest

class WeasylAPIAdapterTests: XCTestCase {

    private func makeWeasylSubmission(submitID: String = "",
                                      title: String = "",
                                      postedAt: Date = Date()) -> WeasylSubmission {
        return WeasylSubmission(submitID: submitID, title: title, postedAt: postedAt)
    }

    func testFetchingHomepageShouldTellTheServiceToPerformFetch() {
        let capturingWeasylAPI = CapturingWeasylAPI()
        let adapter = WeasylAPIAdapter(api: capturingWeasylAPI)
        adapter.loadFeed(delegate: DummyHomepageFeedDelegate())

        XCTAssertTrue(capturingWeasylAPI.didLoadHomepage)
    }

    func testSuccessfullyFetchingWeasylItemAdaptsItemIntoPeekazooDomainObjectWithContentIdentifier() {
        let item = makeWeasylSubmission(submitID: "ID")
        let successfulWeasylAPI = SuccessfulWeasylAPI(items: [item])
        let adapter = WeasylAPIAdapter(api: successfulWeasylAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertEqual(item.submitID, capturingHomepageFeedDelegate.result(at: 0)?.contentIdentifier)
    }

    func testSuccessfullyFetchingWeasylItemAdaptsItemIntoPeekazooDomainObjectWithTitle() {
        let item = makeWeasylSubmission(title: "Title")
        let successfulWeasylAPI = SuccessfulWeasylAPI(items: [item])
        let adapter = WeasylAPIAdapter(api: successfulWeasylAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertEqual(item.title, capturingHomepageFeedDelegate.result(at: 0)?.title)
    }

    func testFailingToFetchWeasylItemTellsDelegateLoadFailed() {
        let failingWeasylAPI = FailingWeasylAPI()
        let adapter = WeasylAPIAdapter(api: failingWeasylAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertTrue(capturingHomepageFeedDelegate.wasNotifiedFeedDidFailToLoad)
    }

    func testSuccessfullyFetchingWeasylItemDoesNotNotifyDelegateOfLoadFailure() {
        let item = makeWeasylSubmission()
        let successfulWeasylAPI = SuccessfulWeasylAPI(items: [item])
        let adapter = WeasylAPIAdapter(api: successfulWeasylAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertFalse(capturingHomepageFeedDelegate.wasNotifiedFeedDidFailToLoad)
    }

    func testSuccessfullyFetchingMultipleWeasylItemsAdaptsSecondItemTitle() {
        let firstItem = makeWeasylSubmission(title: "Title")
        let secondItem = makeWeasylSubmission(title: "Another Title")
        let successfulWeasylAPI = SuccessfulWeasylAPI(items: [firstItem, secondItem])
        let adapter = WeasylAPIAdapter(api: successfulWeasylAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertEqual(secondItem.title, capturingHomepageFeedDelegate.result(at: 1)?.title)
    }

    func testSuccessfullyFetchingItemAdaptsPostedAtDate() {
        let postedAt = Date(timeIntervalSinceNow: -7200)
        let item = makeWeasylSubmission(postedAt: postedAt)
        let successfulWeasylAPI = SuccessfulWeasylAPI(items: [item])
        let adapter = WeasylAPIAdapter(api: successfulWeasylAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertEqual(postedAt, capturingHomepageFeedDelegate.capturedResults?.first?.creationDate)
    }

}
