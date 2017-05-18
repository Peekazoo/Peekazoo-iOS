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

    func loadHomepage(completionHandler: ([WeasylHomepageItem]) -> Void)

}

class CapturingWeasylService: WeasylServiceProtocol {

    private(set) var didLoadHomepage = false
    func loadHomepage(completionHandler: ([WeasylHomepageItem]) -> Void) {
        didLoadHomepage = true
    }

}

struct SuccessfulWeasylService: WeasylServiceProtocol {

    var items: [WeasylHomepageItem]

    func loadHomepage(completionHandler: ([WeasylHomepageItem]) -> Void) {
        completionHandler(items)
    }

}

struct WeasylServiceAdapter: HomepageFeed {

    private struct AdaptedItem: HomepageItem {

        var weasylItem: WeasylHomepageItem

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
        let item = WeasylHomepageItem(submitID: "ID", title: "Title")
        let successfulWeasylService = SuccessfulWeasylService(items: [item])
        let adapter = WeasylServiceAdapter(service: successfulWeasylService)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)
        let fetchedItem = capturingHomepageFeedDelegate.capturedResults?.first

        XCTAssertEqual(item.contentIdentifier, fetchedItem?.contentIdentifier)
    }

}
