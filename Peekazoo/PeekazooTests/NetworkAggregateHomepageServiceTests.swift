//
//  NetworkAggregateHomepageServiceTests.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 16/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo
import XCTest

class NetworkAggregateHomepageServiceTests: XCTestCase {

    var service: NetworkAggregateHomepageService!
    var capturingLoadingDelegate: CapturingHomepageServiceLoadingDelegate!
    var networkAdapter: DummyNetworkAdapter!

    override func setUp() {
        super.setUp()

        capturingLoadingDelegate = CapturingHomepageServiceLoadingDelegate()
        networkAdapter = DummyNetworkAdapter()
    }

    private func loadHomepage() {
        service.loadHomepage(delegate: capturingLoadingDelegate)
    }

    func testWhenLoadingAllFeedsAreToldToLoad() {
        let count = Int.random(upperLimit: 100, lowerLimit: 2)
        let feeds = (0..<count).map({ _ in CapturingHomepageFeed() })
        service = NetworkAggregateHomepageService(feeds: feeds, networkAdapter: networkAdapter)
        loadHomepage()

        XCTAssertTrue(feeds.all({ $0.didLoad }))
    }

    func testWhenLoadingTheFeedIsGivenTheNetworkAdapter() {
        let feed = CapturingHomepageFeed()
        service = NetworkAggregateHomepageService(feeds: [feed], networkAdapter: networkAdapter)
        loadHomepage()

        XCTAssertTrue((feed.capturedNetworkAdapter as? DummyNetworkAdapter) === networkAdapter)
    }

}
