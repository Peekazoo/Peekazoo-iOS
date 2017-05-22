//
//  InkbunnyAPIAdapter.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 20/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

public struct InkbunnyAPIAdapter: HomepageFeed {

    private var api: InkbunnyAPIProtocol

    public init(api: InkbunnyAPIProtocol) {
        self.api = api
    }

    public func loadFeed(delegate: HomepageFeedDelegate) {
        api.loadHomepage { result in
            switch result {
            case .success(let items):
                let homepageItems = items.map(AdaptedItem.init)
                delegate.feedDidFinishLoading(items: homepageItems)

            case .failure:
                delegate.feedDidFailToLoad()
            }
        }
    }

    private struct AdaptedItem: HomepageItem {

        private var submission: InkbunnySubmission

        var title: String { return submission.title }
        var contentIdentifier: String { return submission.submissionID }
        var creationDate: Date { return submission.postedDate }

        init(submission: InkbunnySubmission) {
            self.submission = submission
        }

    }

}
