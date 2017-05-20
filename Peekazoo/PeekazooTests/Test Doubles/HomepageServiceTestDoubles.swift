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
    private(set) var capturedDelegate: HomepageServiceLoadingDelegate?
    func loadHomepage(delegate: HomepageServiceLoadingDelegate) {
        didLoad = true
        capturedDelegate = delegate
    }

    func simulateSuccessfulLoad(content: [StubHomepageItem] = []) {
        capturedDelegate?.homepageServiceDidLoadSuccessfully(content: content)
    }

    func simulateFailedLoad() {
        capturedDelegate?.homepageServiceDidFailToLoad()
    }

}

class JournallingHomepageService: HomepageService {

    private(set) var numberOfLoads = 0
    func loadHomepage(delegate: HomepageServiceLoadingDelegate) {
        numberOfLoads += 1
    }

}

struct SuccessfulHomepageService: HomepageService {

    var content: [HomepageItem]

    init() {
        content = []
    }

    init(content: [HomepageItem]) {
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
