//
//  HomepageLoadTask.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 22/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

class HomepageLoadTask: HomepageFeedDelegate {

    private let feeds: [HomepageFeed]
    private let delegate: HomepageLoadingDelegate
    private let delegateWorker: Worker
    private var numberOfLoadingFeeds = 0
    private var numberOfSuccessfulFeeds = 0
    private var loadedItems = [HomepageItem]()

    public init(feeds: [HomepageFeed], delegate: HomepageLoadingDelegate, delegateWorker: Worker) {
        self.feeds = feeds
        self.delegate = delegate
        self.delegateWorker = delegateWorker
    }

    public func loadHomepage() {
        numberOfLoadingFeeds = feeds.count
        numberOfSuccessfulFeeds = 0
        feeds.forEach(beginLoad)
    }

    public func feedDidFinishLoading(items: [HomepageItem]) {
        loadedItems.append(contentsOf: items)
        numberOfSuccessfulFeeds += 1
        handleFeedFinished()
    }

    public func feedDidFailToLoad() {
        handleFeedFinished()
    }

    private func beginLoad(for feed: HomepageFeed) {
        feed.loadFeed(delegate: self)
    }

    private func handleFeedFinished() {
        numberOfLoadingFeeds -= 1
        guard isFinishedLoading else { return }

        delegateWorker.execute(notifyDelegate)
    }

    private var isFinishedLoading: Bool {
        return numberOfLoadingFeeds == 0
    }

    private var isLoadSuccessful: Bool {
        return numberOfSuccessfulFeeds > 0
    }

    private func notifyDelegate() {
        if isLoadSuccessful {
            delegate.finishedLoadingHomepage(items: loadedItems)
        } else {
            delegate.failedToLoadHomepage()
        }
    }

}
