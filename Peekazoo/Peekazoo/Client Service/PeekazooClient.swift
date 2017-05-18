//
//  PeekazooClient.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 16/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

protocol HomepageFeed {

    func loadFeed(networkAdapter: NetworkAdapter, delegate: HomepageFeedDelegate)

}

protocol HomepageFeedDelegate {

    func feedDidFinishLoading(items: [HomepageItem])
    func feedDidFailToLoad()

}

class PeekazooClient: HomepageService, HomepageFeedDelegate {

    var feeds: [HomepageFeed]
    var networkAdapter: NetworkAdapter
    var delegate: HomepageServiceLoadingDelegate?

    init(feeds: [HomepageFeed], networkAdapter: NetworkAdapter) {
        self.feeds = feeds
        self.networkAdapter = networkAdapter
    }

    func loadHomepage(delegate: HomepageServiceLoadingDelegate) {
        self.delegate = delegate
        feeds.forEach(beginLoad)
    }

    func feedDidFinishLoading(items: [HomepageItem]) {
        delegate?.homepageServiceDidLoadSuccessfully(content: items)
    }

    func feedDidFailToLoad() {
        delegate?.homepageServiceDidFailToLoad()
    }

    private func beginLoad(for feed: HomepageFeed) {
        feed.loadFeed(networkAdapter: networkAdapter, delegate: self)
    }

}
