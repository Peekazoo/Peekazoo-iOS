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

    func testWhenLoadingTheFeedIsToldToLoad() {
        let feed = CapturingHomepageFeed()
        let capturingLoadingDelegate = CapturingHomepageServiceLoadingDelegate()
        let service = NetworkAggregateHomepageService(feeds: [feed])
        service.loadHomepage(delegate: capturingLoadingDelegate)

        XCTAssertTrue(feed.didLoad)
    }

    func testWhenLoadingAllFeedsAreToldToLoad() {
        let count = Int.random(upperLimit: 100, lowerLimit: 2)
        let feeds = (0..<count).map({ _ in CapturingHomepageFeed() })
        let capturingLoadingDelegate = CapturingHomepageServiceLoadingDelegate()
        let service = NetworkAggregateHomepageService(feeds: feeds)
        service.loadHomepage(delegate: capturingLoadingDelegate)

        XCTAssertTrue(feeds.all({ $0.didLoad }))
    }

}
