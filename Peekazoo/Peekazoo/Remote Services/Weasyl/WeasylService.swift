//
//  WeasylService.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 18/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

struct WeasylService {

    var networkAdapter: NetworkAdapter
    private let homepageFeed = WeasylHomepageFeed()

    init(networkAdapter: NetworkAdapter) {
        self.networkAdapter = networkAdapter
    }

    func loadHomepage(delegate: HomepageFeedDelegate) {
        homepageFeed.loadFeed(networkAdapter: networkAdapter, delegate: delegate)
    }

}
