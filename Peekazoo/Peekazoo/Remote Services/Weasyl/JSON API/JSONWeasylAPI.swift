//
//  JSONWeasylAPI.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 18/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

public struct JSONWeasylAPI: WeasylAPI {

    private var homepageFeed: JSONWeasylHomepageAPI

    public init(networkAdapter: NetworkAdapter) {
        homepageFeed = JSONWeasylHomepageAPI(networkAdapter: networkAdapter)
    }

    public func loadHomepage(completionHandler: @escaping (WeasylHomepageLoadResult) -> Void) {
        homepageFeed.loadFeed(completionHandler: completionHandler)
    }

}
