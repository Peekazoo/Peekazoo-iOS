//
//  PeekazooClient.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 16/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

public class PeekazooClient: PeekazooServiceProtocol {

    private var feeds: [HomepageFeed]
    private let delegateWorker: Worker
    private var homepageLoadTasks = [HomepageLoadTask]()

    public init(feeds: [HomepageFeed], delegateWorker: Worker) {
        self.feeds = feeds
        self.delegateWorker = delegateWorker
    }

    public func loadHomepage(delegate: HomepageLoadingDelegate) {
        let task = HomepageLoadTask(feeds: feeds, delegate: delegate, delegateWorker: delegateWorker)
        homepageLoadTasks.append(task)
        task.loadHomepage()
    }

}
