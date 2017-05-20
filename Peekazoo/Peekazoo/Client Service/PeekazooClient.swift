//
//  PeekazooClient.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 16/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

protocol HomepageFeed {

    func loadFeed(delegate: HomepageFeedDelegate)

}

protocol HomepageFeedDelegate {

    func feedDidFinishLoading(items: [HomepageItem])
    func feedDidFailToLoad()

}

class PeekazooClient: PeekazooServiceProtocol, HomepageFeedDelegate {

    var feeds: [HomepageFeed]
    var delegate: HomepageLoadingDelegate?
    private var numberOfLoadingFeeds = 0

    init(feeds: [HomepageFeed]) {
        self.feeds = feeds
    }

    func loadHomepage(delegate: HomepageLoadingDelegate) {
        self.delegate = delegate
        numberOfLoadingFeeds = feeds.count
        feeds.forEach(beginLoad)
    }

    func feedDidFinishLoading(items: [HomepageItem]) {
        numberOfLoadingFeeds -= 1

        if numberOfLoadingFeeds == 0 {
            delegate?.finishedLoadingHomepage(items: items)
        }
    }

    func feedDidFailToLoad() {
        delegate?.failedToLoadHomepage()
    }

    private func beginLoad(for feed: HomepageFeed) {
        feed.loadFeed(delegate: self)
    }

}
