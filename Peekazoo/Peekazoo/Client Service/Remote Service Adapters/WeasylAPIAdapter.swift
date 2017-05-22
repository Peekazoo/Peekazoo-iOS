//
//  WeasylAPIAdapter.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 18/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

public struct WeasylAPIAdapter: HomepageFeed {

    private var api: WeasylAPIProtocol

    public init(api: WeasylAPIProtocol) {
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

        var contentIdentifier: String { return weasylItem.submitID }
        var title: String { return weasylItem.title }
        var creationDate: Date { return weasylItem.postedAt }

    }

}
