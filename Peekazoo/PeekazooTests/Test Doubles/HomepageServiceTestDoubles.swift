//
//  HomepageServiceTestDoubles.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 15/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo
import Foundation

class DummyHomepageService: HomepageService {

    func loadHomepage(delegate: HomepageServiceLoadingDelegate) { }

}

class CapturingHomepageService: HomepageService {

    private(set) var didLoad = false
    func loadHomepage(delegate: HomepageServiceLoadingDelegate) {
        didLoad = true
    }

}

class JournallingHomepageService: HomepageService {

    private(set) var numberOfLoads = 0
    func loadHomepage(delegate: HomepageServiceLoadingDelegate) {
        numberOfLoads += 1
    }

}

class SuccessfulHomepageService: HomepageService {

    func loadHomepage(delegate: HomepageServiceLoadingDelegate) {
        delegate.homepageServiceDidLoadSuccessfully()
    }

}

class FailingHomepageService: HomepageService {

    func loadHomepage(delegate: HomepageServiceLoadingDelegate) {
        delegate.homepageServiceDidFailToLoad()
    }

}
