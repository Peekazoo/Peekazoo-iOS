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

    func testFetchingHomepageShouldTellTheServiceToPerformFetch() {
        let capturingWeasylAPI = CapturingWeasylAPI()
        let adapter = WeasylAPIAdapter(api: capturingWeasylAPI)
        adapter.loadFeed(delegate: DummyHomepageFeedDelegate())

        XCTAssertTrue(capturingWeasylAPI.didLoadHomepage)
    }

    func testSuccessfullyFetchingWeasylItemAdaptsItemIntoPeekazooDomainObjectWithContentIdentifier() {
        let item = WeasylSubmission(submitID: "ID", title: "Title")
        let successfulWeasylAPI = SuccessfulWeasylAPI(items: [item])
        let adapter = WeasylAPIAdapter(api: successfulWeasylAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertEqual(item.submitID, capturingHomepageFeedDelegate.result(at: 0)?.contentIdentifier)
    }

    func testSuccessfullyFetchingWeasylItemAdaptsItemIntoPeekazooDomainObjectWithTitle() {
        let item = WeasylSubmission(submitID: "ID", title: "Title")
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
        let item = WeasylSubmission(submitID: "ID", title: "Title")
        let successfulWeasylAPI = SuccessfulWeasylAPI(items: [item])
        let adapter = WeasylAPIAdapter(api: successfulWeasylAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertFalse(capturingHomepageFeedDelegate.wasNotifiedFeedDidFailToLoad)
    }

    func testSuccessfullyFetchingMultipleWeasylItemsAdaptsSecondItemTitle() {
        let firstItem = WeasylSubmission(submitID: "ID", title: "Title")
        let secondItem = WeasylSubmission(submitID: "ID 2", title: "Another Title")
        let successfulWeasylAPI = SuccessfulWeasylAPI(items: [firstItem, secondItem])
        let adapter = WeasylAPIAdapter(api: successfulWeasylAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertEqual(secondItem.title, capturingHomepageFeedDelegate.result(at: 1)?.title)
    }

}
