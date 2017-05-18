//
//  WeasylServiceAdapterTests.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 18/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo
import XCTest

protocol WeasylServiceProtocol {

    func loadHomepage(completionHandler: ([WeasylHomepageFeed.WeasylHomepageItem]) -> Void)

}

class CapturingWeasylService: WeasylServiceProtocol {

    private(set) var didLoadHomepage = false
    func loadHomepage(completionHandler: ([WeasylHomepageFeed.WeasylHomepageItem]) -> Void) {
        didLoadHomepage = true
    }

}

struct SuccessfulWeasylService: WeasylServiceProtocol {

    var items: [WeasylHomepageFeed.WeasylHomepageItem]

    func loadHomepage(completionHandler: ([WeasylHomepageFeed.WeasylHomepageItem]) -> Void) {
        completionHandler(items)
    }

}

struct WeasylServiceAdapter: HomepageFeed {

    private struct AdaptedItem: HomepageItem {

        var weasylItem: WeasylHomepageFeed.WeasylHomepageItem

        var contentIdentifier: String { return weasylItem.contentIdentifier }
        var title: String { return "" }

    }

    var service: WeasylServiceProtocol

    init(service: WeasylServiceProtocol) {
        self.service = service
    }

    func loadFeed(delegate: HomepageFeedDelegate) {
        service.loadHomepage { items in
            guard let item = items.first else { return }

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
        let item = WeasylHomepageFeed.WeasylHomepageItem(contentIdentifier: "ID", title: "Title")
        let successfulWeasylService = SuccessfulWeasylService(items: [item])
        let adapter = WeasylServiceAdapter(service: successfulWeasylService)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)
        let fetchedItem = capturingHomepageFeedDelegate.capturedResults?.first

        XCTAssertEqual(item.contentIdentifier, fetchedItem?.contentIdentifier)
    }

}
