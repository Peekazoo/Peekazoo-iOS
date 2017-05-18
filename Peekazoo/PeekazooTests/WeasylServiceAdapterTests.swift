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

    func loadHomepage()

}

class CapturingWeasylService: WeasylServiceProtocol {

    private(set) var didLoadHomepage = false
    func loadHomepage() {
        didLoadHomepage = true
    }

}

struct WeasylServiceAdapter: HomepageFeed {

    var service: WeasylServiceProtocol

    init(service: WeasylServiceProtocol) {
        self.service = service
    }

    func loadFeed(networkAdapter: NetworkAdapter, delegate: HomepageFeedDelegate) {
        service.loadHomepage()
    }

}

class WeasylServiceAdapterTests: XCTestCase {

    func testFetchingHomepageShouldTellTheServiceToPerformFetch() {
        let capturingWeasylService = CapturingWeasylService()
        let adapter = WeasylServiceAdapter(service: capturingWeasylService)
        adapter.loadFeed(networkAdapter: DummyNetworkAdapter(), delegate: DummyHomepageFeedDelegate())

        XCTAssertTrue(capturingWeasylService.didLoadHomepage)
    }

}
