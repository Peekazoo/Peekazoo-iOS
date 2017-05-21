//
//  HomepageFeedTestDoubles.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 16/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo

class CapturingHomepageFeed: HomepageFeed {

    private(set) var didLoad = false
    private(set) var capturedDelegate: HomepageFeedDelegate?
    func loadFeed(delegate: HomepageFeedDelegate) {
        didLoad = true
        capturedDelegate = delegate
    }

    func performSuccessfulLoad(items: [HomepageItem] = []) {
        capturedDelegate?.feedDidFinishLoading(items: items)
    }

    func performUnsuccessfulLoad() {
        capturedDelegate?.feedDidFailToLoad()
    }

}

class RepeatableyCallableHomepageFeed: HomepageFeed {

    private(set) var capturedDelegates = [HomepageFeedDelegate]()
    func loadFeed(delegate: HomepageFeedDelegate) {
        capturedDelegates.append(delegate)
    }

    func performSuccessfulLoad(items: [HomepageItem] = []) {
        capturedDelegates.forEach({ $0.feedDidFinishLoading(items: items) })
    }

    func performUnsuccessfulLoad() {
        capturedDelegates.forEach({ $0.feedDidFailToLoad() })
    }

}

struct FailingHomepageFeed: HomepageFeed {

    func loadFeed(delegate: HomepageFeedDelegate) {
        delegate.feedDidFailToLoad()
    }

}

struct SuccessfulHomepageFeed: HomepageFeed {

    var items: [HomepageItem]

    init() {
        items = []
    }

    init(items: [HomepageItem]) {
        self.items = items
    }

    func loadFeed(delegate: HomepageFeedDelegate) {
        delegate.feedDidFinishLoading(items: items)
    }

}
