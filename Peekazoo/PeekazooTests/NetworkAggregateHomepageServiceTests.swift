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

}
