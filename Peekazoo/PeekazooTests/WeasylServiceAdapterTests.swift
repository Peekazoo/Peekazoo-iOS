//
//  WeasylServiceAdapterTests.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 18/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo
import XCTest

enum HomepageLoadResult {
    case success([WeasylHomepageItem])
    case failure
}

protocol WeasylServiceProtocol {

    func loadHomepage(completionHandler: (HomepageLoadResult) -> Void)

}

class CapturingWeasylService: WeasylServiceProtocol {

    private(set) var didLoadHomepage = false
    func loadHomepage(completionHandler: (HomepageLoadResult) -> Void) {
        didLoadHomepage = true
    }

}

struct SuccessfulWeasylService: WeasylServiceProtocol {

    var items: [WeasylHomepageItem]

    func loadHomepage(completionHandler: (HomepageLoadResult) -> Void) {
        completionHandler(.success(items))
    }

}

struct FailingWeasylService: WeasylServiceProtocol {

    func loadHomepage(completionHandler: (HomepageLoadResult) -> Void) {
        completionHandler(.failure)
    }

}

struct WeasylServiceAdapter: HomepageFeed {

    private struct AdaptedItem: HomepageItem {

        var weasylItem: WeasylHomepageItem

        var contentIdentifier: String { return weasylItem.submitID }
        var title: String { return weasylItem.title }

    }

    var service: WeasylServiceProtocol

    init(service: WeasylServiceProtocol) {
        self.service = service
    }

    func loadFeed(delegate: HomepageFeedDelegate) {
        delegate.feedDidFailToLoad()
        service.loadHomepage { result in
            guard case .success(let items) = result, let item = items.first else { return }

            let adaptedItem = AdaptedItem(weasylItem: item)
            delegate.feedDidFinishLoading(items: [adaptedItem])
        }
    }

}

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

}
