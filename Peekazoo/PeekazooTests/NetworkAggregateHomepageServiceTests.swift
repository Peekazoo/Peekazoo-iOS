//
//  NetworkAggregateHomepageServiceTests.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 16/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo
import XCTest

class NetworkAggregateHomepageServiceTests: XCTestCase {

    var service: NetworkAggregateHomepageService!
    var capturingLoadingDelegate: CapturingHomepageServiceLoadingDelegate!
    var networkAdapter: DummyNetworkAdapter!
    var firstFeed: CapturingHomepageFeed!
    var secondFeed: CapturingHomepageFeed!

    override func setUp() {
        super.setUp()

        capturingLoadingDelegate = CapturingHomepageServiceLoadingDelegate()
        networkAdapter = DummyNetworkAdapter()
        firstFeed = CapturingHomepageFeed()
        secondFeed = CapturingHomepageFeed()
        service = NetworkAggregateHomepageService(feeds: [firstFeed, secondFeed], networkAdapter: networkAdapter)
    }

    private func loadHomepage() {
        service.loadHomepage(delegate: capturingLoadingDelegate)
    }

    func testWhenLoadingAllFeedsAreToldToLoad() {
        loadHomepage()
        XCTAssertTrue([firstFeed, secondFeed].all({ $0.didLoad }))
    }

    func testWhenLoadingTheFeedIsGivenTheNetworkAdapter() {
        loadHomepage()
        XCTAssertTrue((firstFeed.capturedNetworkAdapter as? DummyNetworkAdapter) === networkAdapter)
    }

    func testWhenFeedFailsToLoadThenTheFailureCallbackIsInvoked() {
        let failingFeed = FailingHomepageFeed()
        service = NetworkAggregateHomepageService(feeds: [failingFeed], networkAdapter: networkAdapter)
        loadHomepage()

        XCTAssertTrue(capturingLoadingDelegate.didFailToLoadInvoked)
    }

    func testWhenSingleFeedLoadsSuccessfullyTheDelegateIsToldAboutIt() {
        let successfulFeed = SuccessfulHomepageFeed()
        service = NetworkAggregateHomepageService(feeds: [successfulFeed], networkAdapter: networkAdapter)
        loadHomepage()

        XCTAssertTrue(capturingLoadingDelegate.didFinishLoadingInvoked)
    }

    func testFeedFailingToLoadShouldNotNotifyDelegateAboutSuccess() {
        let failingFeed = FailingHomepageFeed()
        service = NetworkAggregateHomepageService(feeds: [failingFeed], networkAdapter: networkAdapter)
        loadHomepage()

        XCTAssertFalse(capturingLoadingDelegate.didFinishLoadingInvoked)
    }

    func testFeedLoadingSuccessfullyShouldNotNotifyDelegateAboutFailures() {
        let successfulFeed = SuccessfulHomepageFeed()
        service = NetworkAggregateHomepageService(feeds: [successfulFeed], networkAdapter: networkAdapter)
        loadHomepage()

        XCTAssertFalse(capturingLoadingDelegate.didFailToLoadInvoked)
    }

}
