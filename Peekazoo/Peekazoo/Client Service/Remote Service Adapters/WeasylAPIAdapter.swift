//
//  WeasylAPIAdapter.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 18/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

struct WeasylAPIAdapter: HomepageFeed {

    var api: WeasylAPIProtocol

    init(api: WeasylAPIProtocol) {
        self.api = api
    }

    func loadFeed(delegate: HomepageFeedDelegate) {
        api.loadHomepage { result in
            guard case .success(let items) = result else {
                delegate.feedDidFailToLoad()
                return
            }

            delegate.feedDidFinishLoading(items: items.map(AdaptedItem.init))
        }
    }

    private struct AdaptedItem: HomepageItem {

        var weasylItem: WeasylHomepageItem

        var contentIdentifier: String { return weasylItem.submitID }
        var title: String { return weasylItem.title }

    }

}