//
//  WeasylAPI.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 18/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

struct WeasylAPI: WeasylAPIProtocol {

    private var homepageFeed: WeasylHomepageAPI

    init(networkAdapter: NetworkAdapter) {
        homepageFeed = WeasylHomepageAPI(networkAdapter: networkAdapter)
    }

    func loadHomepage(completionHandler: @escaping (WeasylHomepageLoadResult) -> Void) {
        homepageFeed.loadFeed(completionHandler: completionHandler)
    }

}
