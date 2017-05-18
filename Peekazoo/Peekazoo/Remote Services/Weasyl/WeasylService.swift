//
//  WeasylService.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 18/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

struct WeasylService: WeasylServiceProtocol {

    private var homepageFeed: WeasylHomepageFeed

    init(networkAdapter: NetworkAdapter) {
        homepageFeed = WeasylHomepageFeed(networkAdapter: networkAdapter)
    }

    func loadHomepage(completionHandler: @escaping (WeasylHomepageLoadResult) -> Void) {
        homepageFeed.loadFeed(completionHandler: completionHandler)
    }

}
