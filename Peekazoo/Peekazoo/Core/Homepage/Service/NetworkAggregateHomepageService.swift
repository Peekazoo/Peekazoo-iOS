//
//  NetworkAggregateHomepageService.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 16/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

protocol HomepageFeed {

    func loadFeed(networkAdapter: NetworkAdapter, delegate: HomepageFeedDelegate)

}

protocol HomepageFeedDelegate {

    func feedDidFinishLoading()
    func feedDidFailToLoad()

}

protocol NetworkAdapter {

}

class NetworkAggregateHomepageService: HomepageService, HomepageFeedDelegate {

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

    func feedDidFinishLoading() {
        delegate?.homepageServiceDidLoadSuccessfully(content: [])
    }

    func feedDidFailToLoad() {
        delegate?.homepageServiceDidFailToLoad()
    }

    private func beginLoad(for feed: HomepageFeed) {
        feed.loadFeed(networkAdapter: networkAdapter, delegate: self)
    }

}
