//
//  NetworkAggregateHomepageServiceTests.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 16/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo
import XCTest

class DummyNetworkAdapter: NetworkAdapter {

}

class NetworkAggregateHomepageServiceTests: XCTestCase {

    func testWhenLoadingTheFeedIsToldToLoad() {
        let feed = CapturingHomepageFeed()
        let capturingLoadingDelegate = CapturingHomepageServiceLoadingDelegate()
        let service = NetworkAggregateHomepageService(feeds: [feed], networkAdapter: DummyNetworkAdapter())
        service.loadHomepage(delegate: capturingLoadingDelegate)

        XCTAssertTrue(feed.didLoad)
    }

    func testWhenLoadingAllFeedsAreToldToLoad() {
        let count = Int.random(upperLimit: 100, lowerLimit: 2)
        let feeds = (0..<count).map({ _ in CapturingHomepageFeed() })
        let capturingLoadingDelegate = CapturingHomepageServiceLoadingDelegate()
        let service = NetworkAggregateHomepageService(feeds: feeds, networkAdapter: DummyNetworkAdapter())
        service.loadHomepage(delegate: capturingLoadingDelegate)

        XCTAssertTrue(feeds.all({ $0.didLoad }))
    }

    func testWhenLoadingTheFeedIsGivenTheNetworkAdapter() {
        let dummyNetworkAdapter = DummyNetworkAdapter()
        let feed = CapturingHomepageFeed()
        let capturingLoadingDelegate = CapturingHomepageServiceLoadingDelegate()
        let service = NetworkAggregateHomepageService(feeds: [feed], networkAdapter: dummyNetworkAdapter)
        service.loadHomepage(delegate: capturingLoadingDelegate)

        XCTAssertTrue((feed.capturedNetworkAdapter as? DummyNetworkAdapter) === dummyNetworkAdapter)
    }

}
