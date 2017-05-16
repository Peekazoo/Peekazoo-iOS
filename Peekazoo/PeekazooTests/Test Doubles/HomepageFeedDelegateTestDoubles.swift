//
//  HomepageFeedDelegateTestDoubles.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 16/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo

struct DummyHomepageFeedDelegate: HomepageFeedDelegate {

    func feedDidFinishLoading() { }
    func feedDidFailToLoad() { }

}

class CapturingHomepageFeedDelegate: HomepageFeedDelegate {

    private(set) var wasNotifiedDidFinishLoading = false
    func feedDidFinishLoading() {
        wasNotifiedDidFinishLoading = true
    }

    private(set) var wasNotifiedFeedDidFailToLoad = false
    func feedDidFailToLoad() {
        wasNotifiedFeedDidFailToLoad = true
    }

}
