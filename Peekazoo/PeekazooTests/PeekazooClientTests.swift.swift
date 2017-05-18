//
//  PeekazooClientTests.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 16/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo
import XCTest

class PeekazooClientTests: XCTestCase {

    func testWhenLoadingAllFeedsAreToldToLoad() {
        let firstFeed = CapturingHomepageFeed()
        let secondFeed = CapturingHomepageFeed()
        let capturingLoadingDelegate = CapturingHomepageServiceLoadingDelegate()
        let networkAdapter = DummyNetworkAdapter()
        let service = PeekazooClient(feeds: [firstFeed, secondFeed], networkAdapter: networkAdapter)
        service.loadHomepage(delegate: capturingLoadingDelegate)

        XCTAssertTrue([firstFeed, secondFeed].all({ $0.didLoad }))
    }

    func testWhenLoadingTheFeedIsGivenTheNetworkAdapter() {
        let firstFeed = CapturingHomepageFeed()
        let secondFeed = CapturingHomepageFeed()
        let capturingLoadingDelegate = CapturingHomepageServiceLoadingDelegate()
        let networkAdapter = DummyNetworkAdapter()
        let service = PeekazooClient(feeds: [firstFeed, secondFeed], networkAdapter: networkAdapter)
        service.loadHomepage(delegate: capturingLoadingDelegate)

        XCTAssertTrue((firstFeed.capturedNetworkAdapter as? DummyNetworkAdapter) === networkAdapter)
    }

    func testWhenFeedFailsToLoadThenTheFailureCallbackIsInvoked() {
        let failingFeed = FailingHomepageFeed()
        let capturingLoadingDelegate = CapturingHomepageServiceLoadingDelegate()
        let networkAdapter = DummyNetworkAdapter()
        let service = PeekazooClient(feeds: [failingFeed], networkAdapter: networkAdapter)
        service.loadHomepage(delegate: capturingLoadingDelegate)

        XCTAssertTrue(capturingLoadingDelegate.didFailToLoadInvoked)
    }

    func testWhenSingleFeedLoadsSuccessfullyTheDelegateIsToldAboutIt() {
        let successfulFeed = SuccessfulHomepageFeed()
        let capturingLoadingDelegate = CapturingHomepageServiceLoadingDelegate()
        let networkAdapter = DummyNetworkAdapter()
        let service = PeekazooClient(feeds: [successfulFeed], networkAdapter: networkAdapter)
        service.loadHomepage(delegate: capturingLoadingDelegate)

        XCTAssertTrue(capturingLoadingDelegate.didFinishLoadingInvoked)
    }

    func testFeedFailingToLoadShouldNotNotifyDelegateAboutSuccess() {
        let failingFeed = FailingHomepageFeed()
        let capturingLoadingDelegate = CapturingHomepageServiceLoadingDelegate()
        let networkAdapter = DummyNetworkAdapter()
        let service = PeekazooClient(feeds: [failingFeed], networkAdapter: networkAdapter)
        service.loadHomepage(delegate: capturingLoadingDelegate)

        XCTAssertFalse(capturingLoadingDelegate.didFinishLoadingInvoked)
    }

    func testFeedLoadingSuccessfullyShouldNotNotifyDelegateAboutFailures() {
        let successfulFeed = SuccessfulHomepageFeed()
        let capturingLoadingDelegate = CapturingHomepageServiceLoadingDelegate()
        let networkAdapter = DummyNetworkAdapter()
        let service = PeekazooClient(feeds: [successfulFeed], networkAdapter: networkAdapter)
        service.loadHomepage(delegate: capturingLoadingDelegate)

        XCTAssertFalse(capturingLoadingDelegate.didFailToLoadInvoked)
    }

    func testForSingleFeedItsItemsAreProvidedToTheDelegate() {
        let items = [StubHomepageItem()]
        let successfulFeed = SuccessfulHomepageFeed(items: items)
        let capturingLoadingDelegate = CapturingHomepageServiceLoadingDelegate()
        let networkAdapter = DummyNetworkAdapter()
        let service = PeekazooClient(feeds: [successfulFeed], networkAdapter: networkAdapter)
        service.loadHomepage(delegate: capturingLoadingDelegate)

        XCTAssertEqual(true, (capturingLoadingDelegate.capturedHomepageItems as? [StubHomepageItem])?.elementsEqual(items))
    }

}
