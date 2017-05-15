//
//  HomepageServiceTestDoubles.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 15/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo
import Foundation

struct DummyHomepageService: HomepageService {

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

struct SuccessfulHomepageService: HomepageService {

    var content: [Any]

    init() {
        content = []
    }

    init(content: [Any]) {
        self.content = content
    }

    func loadHomepage(delegate: HomepageServiceLoadingDelegate) {
        delegate.homepageServiceDidLoadSuccessfully(content: content)
    }

}

struct FailingHomepageService: HomepageService {

    func loadHomepage(delegate: HomepageServiceLoadingDelegate) {
        delegate.homepageServiceDidFailToLoad()
    }

}
