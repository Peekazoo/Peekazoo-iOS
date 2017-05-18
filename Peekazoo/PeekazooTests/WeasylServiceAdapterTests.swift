//
//  WeasylServiceAdapterTests.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 18/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo
import XCTest

class WeasylServiceAdapterTests: XCTestCase {

    func testFetchingHomepageShouldTellTheServiceToPerformFetch() {
        let capturingWeasylService = CapturingWeasylService()
        let adapter = WeasylServiceAdapter(service: capturingWeasylService)
        adapter.loadFeed(delegate: DummyHomepageFeedDelegate())

        XCTAssertTrue(capturingWeasylService.didLoadHomepage)
    }

    func testSuccessfullyFetchingWeasylItemAdaptsItemIntoPeekazooDomainObjectWithContentIdentifier() {
        let item = WeasylHomepageItem(submitID: "ID", title: "Title")
        let successfulWeasylService = SuccessfulWeasylService(items: [item])
        let adapter = WeasylServiceAdapter(service: successfulWeasylService)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)
        let fetchedItem = capturingHomepageFeedDelegate.capturedResults?.first

        XCTAssertEqual(item.contentIdentifier, fetchedItem?.contentIdentifier)
    }

    func testSuccessfullyFetchingWeasylItemAdaptsItemIntoPeekazooDomainObjectWithTitle() {
        let item = WeasylHomepageItem(submitID: "ID", title: "Title")
        let successfulWeasylService = SuccessfulWeasylService(items: [item])
        let adapter = WeasylServiceAdapter(service: successfulWeasylService)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)
        let fetchedItem = capturingHomepageFeedDelegate.capturedResults?.first

        XCTAssertEqual(item.title, fetchedItem?.title)
    }

    func testFailingToFetchWeasylItemTellsDelegateLoadFailed() {
        let failingWeasylService = FailingWeasylService()
        let adapter = WeasylServiceAdapter(service: failingWeasylService)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertTrue(capturingHomepageFeedDelegate.wasNotifiedFeedDidFailToLoad)
    }

    func testSuccessfullyFetchingWeasylItemDoesNotNotifyDelegateOfLoadFailure() {
        let item = WeasylHomepageItem(submitID: "ID", title: "Title")
        let successfulWeasylService = SuccessfulWeasylService(items: [item])
        let adapter = WeasylServiceAdapter(service: successfulWeasylService)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertFalse(capturingHomepageFeedDelegate.wasNotifiedFeedDidFailToLoad)
    }

}
