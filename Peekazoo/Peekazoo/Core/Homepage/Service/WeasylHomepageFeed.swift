//
//  WeasylHomepageFeed.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 16/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

struct WeasylHomepageFeed: HomepageFeed {

    let homepageURL = URL(string: "https://www.weasyl.com/api/submissions/frontpage")!

    func loadFeed(networkAdapter: NetworkAdapter, delegate: HomepageFeedDelegate) {
        networkAdapter.get(homepageURL) { data, _ in
            if let data = data {
                if (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) == nil {
                    delegate.feedDidFailToLoad()
                }

                delegate.feedDidFinishLoading()
            } else {
                delegate.feedDidFailToLoad()
            }
        }
    }

}
