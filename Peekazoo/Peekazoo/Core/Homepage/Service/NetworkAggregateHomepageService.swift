//
//  NetworkAggregateHomepageService.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 16/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

protocol HomepageFeed {

    func loadFeed()

}

struct NetworkAggregateHomepageService: HomepageService {

    var feeds: [HomepageFeed]

    init(feeds: [HomepageFeed]) {
        self.feeds = feeds
    }

    func loadHomepage(delegate: HomepageServiceLoadingDelegate) {
        feeds.forEach({ $0.loadFeed() })
    }

}
