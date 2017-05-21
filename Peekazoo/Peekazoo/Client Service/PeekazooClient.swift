//
//  PeekazooClient.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 16/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

protocol HomepageFeed {

    func loadFeed(delegate: HomepageFeedDelegate)

}

protocol HomepageFeedDelegate {

    func feedDidFinishLoading(items: [HomepageItem])
    func feedDidFailToLoad()

}

class PeekazooClient: PeekazooServiceProtocol {

    private class HomepageLoadTask: HomepageFeedDelegate {

        private let feeds: [HomepageFeed]
        private let delegate: HomepageLoadingDelegate
        private let delegateWorker: Worker
        private var numberOfLoadingFeeds = 0
        private var numberOfSuccessfulFeeds = 0
        private var loadedItems = [HomepageItem]()

        init(feeds: [HomepageFeed], delegate: HomepageLoadingDelegate, delegateWorker: Worker) {
            self.feeds = feeds
            self.delegate = delegate
            self.delegateWorker = delegateWorker
        }

        func loadHomepage() {
            numberOfLoadingFeeds = feeds.count
            numberOfSuccessfulFeeds = 0
            feeds.forEach(beginLoad)
        }

        func feedDidFinishLoading(items: [HomepageItem]) {
            loadedItems.append(contentsOf: items)
            numberOfLoadingFeeds -= 1
            numberOfSuccessfulFeeds += 1

            if numberOfLoadingFeeds == 0 {
                delegateWorker.execute {
                    self.delegate.finishedLoadingHomepage(items: self.loadedItems)
                }
            }
        }

        func feedDidFailToLoad() {
            numberOfLoadingFeeds -= 1
            guard numberOfLoadingFeeds == 0 else { return }

            if numberOfSuccessfulFeeds > 0 {
                delegate.finishedLoadingHomepage(items: loadedItems)
            } else {
                delegate.failedToLoadHomepage()
            }
        }

        private func beginLoad(for feed: HomepageFeed) {
            feed.loadFeed(delegate: self)
        }

    }

    var feeds: [HomepageFeed]
    private let delegateWorker: Worker
    private var homepageLoadTasks = [HomepageLoadTask]()

    private struct AutoRunningWorker: Worker {
        func execute(_ work: () -> Void) {
            work()
        }
    }

    init(feeds: [HomepageFeed]) {
        self.feeds = feeds
        self.delegateWorker = AutoRunningWorker()
    }

    init(feeds: [HomepageFeed], delegateWorker: Worker) {
        self.feeds = feeds
        self.delegateWorker = delegateWorker
    }

    func loadHomepage(delegate: HomepageLoadingDelegate) {
        let task = HomepageLoadTask(feeds: feeds, delegate: delegate, delegateWorker: delegateWorker)
        homepageLoadTasks.append(task)
        task.loadHomepage()
    }

}
