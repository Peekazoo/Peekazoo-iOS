//
//  HomepageFeed.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 22/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

public protocol HomepageFeed {

    func loadFeed(delegate: HomepageFeedDelegate)

}

public protocol HomepageFeedDelegate {

    func feedDidFinishLoading(items: [HomepageItem])
    func feedDidFailToLoad()

}
