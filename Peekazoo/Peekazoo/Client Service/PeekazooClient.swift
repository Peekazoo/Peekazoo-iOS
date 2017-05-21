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
    private var delegates = [HomepageLoadingDelegate]()
    private var numberOfLoadingFeeds = 0
    private var numberOfSuccessfulFeeds = 0
    private var loadedItems = [HomepageItem]()

    init(feeds: [HomepageFeed]) {
        self.feeds = feeds
    }

    func loadHomepage(delegate: HomepageLoadingDelegate) {
        delegates.append(delegate)
        numberOfLoadingFeeds = feeds.count
        numberOfSuccessfulFeeds = 0
        feeds.forEach(beginLoad)
    }

    func feedDidFinishLoading(items: [HomepageItem]) {
        loadedItems.append(contentsOf: items)
        numberOfLoadingFeeds -= 1
        numberOfSuccessfulFeeds += 1

        if numberOfLoadingFeeds == 0 {
            delegates.forEach({ $0.finishedLoadingHomepage(items: loadedItems) })
        }
    }

    func feedDidFailToLoad() {
        numberOfLoadingFeeds -= 1
        guard numberOfLoadingFeeds == 0 else { return }

        if numberOfSuccessfulFeeds > 0 {
            delegates.forEach({ $0.finishedLoadingHomepage(items: loadedItems) })
        } else {
            delegates.forEach({ $0.failedToLoadHomepage() })
        }
    }

    private func beginLoad(for feed: HomepageFeed) {
        feed.loadFeed(delegate: self)
    }

}
