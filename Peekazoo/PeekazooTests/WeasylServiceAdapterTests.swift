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

    private func makeWeasylSubmissionImpl(submitID: String = "",
                                      title: String = "",
                                      postedAt: Date = Date()) -> WeasylSubmissionImpl {
        return WeasylSubmissionImpl(submitID: submitID, title: title, postedAt: postedAt)
    }

    func testFetchingHomepageShouldTellTheServiceToPerformFetch() {
        let capturingWeasylAPI = CapturingWeasylAPI()
        let adapter = WeasylHomepageAdapter(api: capturingWeasylAPI)
        adapter.loadFeed(delegate: DummyHomepageFeedDelegate())

        XCTAssertTrue(capturingWeasylAPI.didLoadHomepage)
    }

    func testSuccessfullyFetchingWeasylItemAdaptsItemIntoPeekazooDomainObjectWithContentIdentifier() {
        let item = makeWeasylSubmissionImpl(submitID: "ID")
        let successfulWeasylAPI = SuccessfulWeasylAPI(items: [item])
        let adapter = WeasylHomepageAdapter(api: successfulWeasylAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertEqual(item.submitID, capturingHomepageFeedDelegate.result(at: 0)?.contentIdentifier)
    }

    func testSuccessfullyFetchingWeasylItemAdaptsItemIntoPeekazooDomainObjectWithTitle() {
        let item = makeWeasylSubmissionImpl(title: "Title")
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
        let item = makeWeasylSubmissionImpl()
        let successfulWeasylAPI = SuccessfulWeasylAPI(items: [item])
        let adapter = WeasylHomepageAdapter(api: successfulWeasylAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertFalse(capturingHomepageFeedDelegate.wasNotifiedFeedDidFailToLoad)
    }

    func testSuccessfullyFetchingMultipleWeasylItemsAdaptsSecondItemTitle() {
        let firstItem = makeWeasylSubmissionImpl(title: "Title")
        let secondItem = makeWeasylSubmissionImpl(title: "Another Title")
        let successfulWeasylAPI = SuccessfulWeasylAPI(items: [firstItem, secondItem])
        let adapter = WeasylHomepageAdapter(api: successfulWeasylAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertEqual(secondItem.title, capturingHomepageFeedDelegate.result(at: 1)?.title)
    }

    func testSuccessfullyFetchingItemAdaptsPostedAtDate() {
        let postedAt = Date(timeIntervalSinceNow: -7200)
        let item = makeWeasylSubmissionImpl(postedAt: postedAt)
        let successfulWeasylAPI = SuccessfulWeasylAPI(items: [item])
        let adapter = WeasylHomepageAdapter(api: successfulWeasylAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertEqual(postedAt, capturingHomepageFeedDelegate.capturedResults?.first?.creationDate)
    }

}
