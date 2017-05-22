//
//  HomepageFeedDelegateTestDoubles.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 16/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Peekazoo

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

    func result(at index: Int) -> HomepageItem? {
        guard let results = capturedResults, index < results.count else { return nil }
        return results[index]
    }

}
