//
//  HomepageFeedDelegateTestDoubles.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 16/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo

struct DummyHomepageFeedDelegate: HomepageFeedDelegate {

    func feedDidFinishLoading(items: [HomepageItem]) { }
    func feedDidFailToLoad() { }

}

class CapturingHomepageFeedDelegate: HomepageFeedDelegate {

    private(set) var wasNotifiedDidFinishLoading = false
    private(set) var capturedResults: [HomepageItem]?
    func feedDidFinishLoading(items: [HomepageItem]) {
        wasNotifiedDidFinishLoading = true
        capturedResults = items
    }

    private(set) var wasNotifiedFeedDidFailToLoad = false
    func feedDidFailToLoad() {
        wasNotifiedFeedDidFailToLoad = true
    }

}
