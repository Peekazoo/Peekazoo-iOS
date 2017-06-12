//
//  WeasylHomepageAdapter.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 18/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

public struct WeasylHomepageAdapter: HomepageFeed {

    private var api: WeasylAPI

    public init(api: WeasylAPI) {
        self.api = api
    }

    public func loadFeed(delegate: HomepageFeedDelegate) {
        api.loadHomepage { result in
            guard case .success(let items) = result else {
                delegate.feedDidFailToLoad()
                return
            }

            delegate.feedDidFinishLoading(items: items.map(AdaptedItem.init))
        }
    }

    private struct AdaptedItem: HomepageItem {

        var weasylItem: WeasylSubmission

        var contentIdentifier: String { return String(weasylItem.submitID) }
        var title: String { return weasylItem.title }
        var creationDate: Date { return weasylItem.postedAt }

    }

}
