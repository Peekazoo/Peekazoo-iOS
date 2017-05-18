//
//  WeasylServiceAdapter.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 18/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

struct WeasylServiceAdapter: HomepageFeed {

    var service: WeasylServiceProtocol

    init(service: WeasylServiceProtocol) {
        self.service = service
    }

    func loadFeed(delegate: HomepageFeedDelegate) {
        service.loadHomepage { result in
            guard case .success(let items) = result, let item = items.first else {
                delegate.feedDidFailToLoad()
                return
            }

            let adaptedItem = AdaptedItem(weasylItem: item)
            delegate.feedDidFinishLoading(items: [adaptedItem])
        }
    }

    private struct AdaptedItem: HomepageItem {

        var weasylItem: WeasylHomepageItem

        var contentIdentifier: String { return weasylItem.submitID }
        var title: String { return weasylItem.title }

    }

}
