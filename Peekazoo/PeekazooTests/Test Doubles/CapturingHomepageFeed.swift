//
//  CapturingHomepageFeed.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 16/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo

class CapturingHomepageFeed: HomepageFeed {

    private(set) var didLoad = false
    private(set) var capturedNetworkAdapter: NetworkAdapter?
    func loadFeed(networkAdapter: NetworkAdapter) {
        didLoad = true
        capturedNetworkAdapter = networkAdapter
    }

}
