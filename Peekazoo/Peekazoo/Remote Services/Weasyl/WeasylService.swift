//
//  WeasylService.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 18/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

struct WeasylService {

    private var homepageFeed: WeasylHomepageFeed

    init(networkAdapter: NetworkAdapter) {
        homepageFeed = WeasylHomepageFeed(networkAdapter: networkAdapter)
    }

    func loadHomepage(delegate: HomepageFeedDelegate) {
        homepageFeed.loadFeed(delegate: delegate)
    }

}
