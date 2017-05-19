//
//  PeekazooServiceProtocolTestDoubles.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 19/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo

class CapturingPeekazooService: PeekazooServiceProtocol {

    private(set) var didRequestLoadHomepage = false
    func loadHomepage(delegate: HomepageLoadingDelegate) {
        didRequestLoadHomepage = true
    }

}

struct FailingPeekazooService: PeekazooServiceProtocol {

    func loadHomepage(delegate: HomepageLoadingDelegate) {
        delegate.failedToLoadHomepage()
    }

}

struct SucceedingPeekazooService: PeekazooServiceProtocol {

    var items: [HomepageItem]

    init(items: [HomepageItem] = []) {
        self.items = items
    }

    func loadHomepage(delegate: HomepageLoadingDelegate) {
        delegate.finishedLoadingHomepage(items: items)
    }

}
