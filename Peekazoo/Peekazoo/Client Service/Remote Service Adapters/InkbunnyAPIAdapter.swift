//
//  InkbunnyAPIAdapter.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 20/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

struct InkbunnyAPIAdapter: HomepageFeed {

    var api: InkbunnyAPIProtocol

    init(api: InkbunnyAPIProtocol) {
        self.api = api
    }

    func loadFeed(delegate: HomepageFeedDelegate) {
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

        init(submission: InkbunnySubmission) {
            self.submission = submission
        }

    }

}
