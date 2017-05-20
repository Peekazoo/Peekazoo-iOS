//
//  InkbunnyAPIAdapterTests.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 20/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo
import XCTest

protocol InkbunnyAPIProtocol {

    func loadHomepage(completionHandler: @escaping (InkbunnyHomepageLoadResult) -> Void)

}

class CapturingInkbunnyAPI: InkbunnyAPIProtocol {

    private(set) var didLoadHomepage = false
    func loadHomepage(completionHandler: @escaping (InkbunnyHomepageLoadResult) -> Void) {
        didLoadHomepage = true
    }

}

struct InkbunnyAPIAdapter: HomepageFeed {

    var api: InkbunnyAPIProtocol

    init(api: InkbunnyAPIProtocol) {
        self.api = api
    }

    func loadFeed(delegate: HomepageFeedDelegate) {
        api.loadHomepage { _ in

        }
    }

}

class InkbunnyAPIAdapterTests: XCTestCase {

    func testFetchingHomepageShouldTellAPIToFetchHomepage() {
        let capturingInkbunnyAPI = CapturingInkbunnyAPI()
        let adapter = InkbunnyAPIAdapter(api: capturingInkbunnyAPI)
        adapter.loadFeed(delegate: DummyHomepageFeedDelegate())

        XCTAssertTrue(capturingInkbunnyAPI.didLoadHomepage)
    }

}
