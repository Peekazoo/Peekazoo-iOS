//
//  WeasylAPIAdapterTests.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 18/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo
import XCTest

class WeasylAPIAdapterTests: XCTestCase {

    func testFetchingHomepageShouldTellTheServiceToPerformFetch() {
        let capturingWeasylAPI = CapturingWeasylAPI()
        let adapter = WeasylAPIAdapter(api: capturingWeasylAPI)
        adapter.loadFeed(delegate: DummyHomepageFeedDelegate())

        XCTAssertTrue(capturingWeasylAPI.didLoadHomepage)
    }

    func testSuccessfullyFetchingWeasylItemAdaptsItemIntoPeekazooDomainObjectWithContentIdentifier() {
        let item = WeasylHomepageItem(submitID: "ID", title: "Title")
        let successfulWeasylAPI = SuccessfulWeasylAPI(items: [item])
        let adapter = WeasylAPIAdapter(api: successfulWeasylAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)
        let fetchedItem = capturingHomepageFeedDelegate.capturedResults?.first

        XCTAssertEqual(item.submitID, fetchedItem?.contentIdentifier)
    }

    func testSuccessfullyFetchingWeasylItemAdaptsItemIntoPeekazooDomainObjectWithTitle() {
        let item = WeasylHomepageItem(submitID: "ID", title: "Title")
        let successfulWeasylAPI = SuccessfulWeasylAPI(items: [item])
        let adapter = WeasylAPIAdapter(api: successfulWeasylAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)
        let fetchedItem = capturingHomepageFeedDelegate.capturedResults?.first

        XCTAssertEqual(item.title, fetchedItem?.title)
    }

    func testFailingToFetchWeasylItemTellsDelegateLoadFailed() {
        let failingWeasylAPI = FailingWeasylAPI()
        let adapter = WeasylAPIAdapter(api: failingWeasylAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertTrue(capturingHomepageFeedDelegate.wasNotifiedFeedDidFailToLoad)
    }

    func testSuccessfullyFetchingWeasylItemDoesNotNotifyDelegateOfLoadFailure() {
        let item = WeasylHomepageItem(submitID: "ID", title: "Title")
        let successfulWeasylAPI = SuccessfulWeasylAPI(items: [item])
        let adapter = WeasylAPIAdapter(api: successfulWeasylAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertFalse(capturingHomepageFeedDelegate.wasNotifiedFeedDidFailToLoad)
    }

    func testSuccessfullyFetchingMultipleWeasylItemsAdaptsSecondItemTitle() {
        let firstItem = WeasylHomepageItem(submitID: "ID", title: "Title")
        let secondItem = WeasylHomepageItem(submitID: "ID 2", title: "Another Title")
        let successfulWeasylAPI = SuccessfulWeasylAPI(items: [firstItem, secondItem])
        let adapter = WeasylAPIAdapter(api: successfulWeasylAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        guard let results = capturingHomepageFeedDelegate.capturedResults, results.count > 1 else {
            XCTFail()
            return
        }

        let fetchedItem = results[1]

        XCTAssertEqual(secondItem.title, fetchedItem.title)
    }

}
