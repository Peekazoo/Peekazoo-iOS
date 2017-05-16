//
//  NetworkAggregateHomepageService.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 16/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

protocol HomepageFeed {

    func loadFeed(networkAdapter: NetworkAdapter)

}

protocol NetworkAdapter {

}

struct NetworkAggregateHomepageService: HomepageService {

    var feeds: [HomepageFeed]
    var networkAdapter: NetworkAdapter

    init(feeds: [HomepageFeed], networkAdapter: NetworkAdapter) {
        self.feeds = feeds
        self.networkAdapter = networkAdapter
    }

    func loadHomepage(delegate: HomepageServiceLoadingDelegate) {
        feeds.forEach(beginLoad)
    }

    private func beginLoad(for feed: HomepageFeed) {
        feed.loadFeed(networkAdapter: networkAdapter)
    }

}
