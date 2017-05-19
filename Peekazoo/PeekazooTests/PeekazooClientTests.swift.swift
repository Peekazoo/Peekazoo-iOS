//
//  PeekazooClientTests.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 16/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo
import XCTest

class CapturingHomepageLoadingDelegate: HomepageLoadingDelegate {

    private(set) var didFinishLoadingInvoked = false
    private(set) var capturedHomepageItems: [HomepageItem]?
    func finishedLoadingHomepage(items: [HomepageItem]) {
        didFinishLoadingInvoked = true
        capturedHomepageItems = items
    }

    private(set) var didFailToLoadInvoked = false
    func failedToLoadHomepage() {
        didFailToLoadInvoked = true
    }

}

class PeekazooClientTests: XCTestCase {

    func testWhenLoadingAllFeedsAreToldToLoad() {
        let firstFeed = CapturingHomepageFeed()
        let secondFeed = CapturingHomepageFeed()
        let capturingLoadingDelegate = CapturingHomepageLoadingDelegate()
        let service = PeekazooClient(feeds: [firstFeed, secondFeed])
        service.loadHomepage(delegate: capturingLoadingDelegate)

        XCTAssertTrue([firstFeed, secondFeed].all({ $0.didLoad }))
    }

    func testWhenFeedFailsToLoadThenTheFailureCallbackIsInvoked() {
        let failingFeed = FailingHomepageFeed()
        let capturingLoadingDelegate = CapturingHomepageLoadingDelegate()
        let service = PeekazooClient(feeds: [failingFeed])
        service.loadHomepage(delegate: capturingLoadingDelegate)

        XCTAssertTrue(capturingLoadingDelegate.didFailToLoadInvoked)
    }

    func testWhenSingleFeedLoadsSuccessfullyTheDelegateIsToldAboutIt() {
        let successfulFeed = SuccessfulHomepageFeed()
        let capturingLoadingDelegate = CapturingHomepageLoadingDelegate()
        let service = PeekazooClient(feeds: [successfulFeed])
        service.loadHomepage(delegate: capturingLoadingDelegate)

        XCTAssertTrue(capturingLoadingDelegate.didFinishLoadingInvoked)
    }

    func testFeedFailingToLoadShouldNotNotifyDelegateAboutSuccess() {
        let failingFeed = FailingHomepageFeed()
        let capturingLoadingDelegate = CapturingHomepageLoadingDelegate()
        let service = PeekazooClient(feeds: [failingFeed])
        service.loadHomepage(delegate: capturingLoadingDelegate)

        XCTAssertFalse(capturingLoadingDelegate.didFinishLoadingInvoked)
    }

    func testFeedLoadingSuccessfullyShouldNotNotifyDelegateAboutFailures() {
        let successfulFeed = SuccessfulHomepageFeed()
        let capturingLoadingDelegate = CapturingHomepageLoadingDelegate()
        let service = PeekazooClient(feeds: [successfulFeed])
        service.loadHomepage(delegate: capturingLoadingDelegate)

        XCTAssertFalse(capturingLoadingDelegate.didFailToLoadInvoked)
    }

    func testForSingleFeedItsItemsAreProvidedToTheDelegate() {
        let items = [StubHomepageItem()]
        let successfulFeed = SuccessfulHomepageFeed(items: items)
        let capturingLoadingDelegate = CapturingHomepageLoadingDelegate()
        let service = PeekazooClient(feeds: [successfulFeed])
        service.loadHomepage(delegate: capturingLoadingDelegate)

        XCTAssertEqual(true, (capturingLoadingDelegate.capturedHomepageItems as? [StubHomepageItem])?.elementsEqual(items))
    }

}
