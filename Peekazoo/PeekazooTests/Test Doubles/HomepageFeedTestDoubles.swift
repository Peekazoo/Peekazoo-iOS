//
//  HomepageFeedTestDoubles.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 16/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo

class CapturingHomepageFeed: HomepageFeed {

    private(set) var didLoad = false
    private(set) var capturedNetworkAdapter: NetworkAdapter?
    func loadFeed(networkAdapter: NetworkAdapter, delegate: HomepageFeedDelegate) {
        didLoad = true
        capturedNetworkAdapter = networkAdapter
    }

}

struct FailingHomepageFeed: HomepageFeed {

    func loadFeed(networkAdapter: NetworkAdapter, delegate: HomepageFeedDelegate) {
        delegate.feedDidFailToLoad()
    }

}

struct SuccessfulHomepageFeed: HomepageFeed {

    var items: [HomepageItem]

    init() {
        items = []
    }

    init(items: [HomepageItem]) {
        self.items = items
    }

    func loadFeed(networkAdapter: NetworkAdapter, delegate: HomepageFeedDelegate) {
        delegate.feedDidFinishLoading(items: items)
    }

}
