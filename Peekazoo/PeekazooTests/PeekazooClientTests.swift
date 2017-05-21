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

        XCTAssertTrue(capturingLoadingDelegate.capturedItemsEqual(to: items))
    }

    func testWhenOneFeedFinishesLoadingWhileAnotherIsInProgressTheDelegateIsNotToldToLoadFinished() {
        let firstFeed = SuccessfulHomepageFeed()
        let secondFeed = CapturingHomepageFeed()
        let capturingLoadingDelegate = CapturingHomepageLoadingDelegate()
        let service = PeekazooClient(feeds: [firstFeed, secondFeed])
        service.loadHomepage(delegate: capturingLoadingDelegate)

        XCTAssertFalse(capturingLoadingDelegate.didFinishLoadingInvoked)
    }

    func testWhenBothFeedsFinishLoadingTheFirstFeedsResultsAreProvidedToTheDelegate() {
        let firstFeedItems = [StubHomepageItem(title: "Feed 1 Item")]
        let firstSuccessfulFeed = SuccessfulHomepageFeed(items: firstFeedItems)
        let secondFeedItems = [StubHomepageItem(title: "Feed 2 Item")]
        let secondSuccessfulFeed = SuccessfulHomepageFeed(items: secondFeedItems)
        let capturingLoadingDelegate = CapturingHomepageLoadingDelegate()
        let service = PeekazooClient(feeds: [firstSuccessfulFeed, secondSuccessfulFeed])
        service.loadHomepage(delegate: capturingLoadingDelegate)

        XCTAssertTrue(capturingLoadingDelegate.capturedItemsContains(firstFeedItems))
    }

    func testWhenTheFirstFeedLoadsItemsThenTheSecondFeedFailsTheDelegateIsGivenTheLoadedItems() {
        let successfulFeed = SuccessfulHomepageFeed()
        let failingFeed = FailingHomepageFeed()
        let capturingLoadingDelegate = CapturingHomepageLoadingDelegate()
        let service = PeekazooClient(feeds: [successfulFeed, failingFeed])
        service.loadHomepage(delegate: capturingLoadingDelegate)

        XCTAssertTrue(capturingLoadingDelegate.didFinishLoadingInvoked)
    }

    func testWhenTheFirstFeedLoadsItemsThenTheSecondFeedFailsTheDelegateIsNotToldAboutFailure() {
        let successfulFeed = SuccessfulHomepageFeed()
        let failingFeed = FailingHomepageFeed()
        let capturingLoadingDelegate = CapturingHomepageLoadingDelegate()
        let service = PeekazooClient(feeds: [successfulFeed, failingFeed])
        service.loadHomepage(delegate: capturingLoadingDelegate)

        XCTAssertFalse(capturingLoadingDelegate.didFailToLoadInvoked)
    }

    func testWhenTheFirstFeedFailsToLoadThenTheSecondFeedSucceedsTheDelegateIsNotToldAboutFailure() {
        let successfulFeed = SuccessfulHomepageFeed()
        let failingFeed = FailingHomepageFeed()
        let capturingLoadingDelegate = CapturingHomepageLoadingDelegate()
        let service = PeekazooClient(feeds: [failingFeed, successfulFeed])
        service.loadHomepage(delegate: capturingLoadingDelegate)

        XCTAssertFalse(capturingLoadingDelegate.didFailToLoadInvoked)
    }

    func testFullySuccessfulLoadThenFailingLoadsAreNotRegardedAsSuccess() {
        let capturingHomepageFeed = CapturingHomepageFeed()
        var capturingLoadingDelegate = CapturingHomepageLoadingDelegate()
        let service = PeekazooClient(feeds: [capturingHomepageFeed])
        service.loadHomepage(delegate: capturingLoadingDelegate)
        capturingHomepageFeed.performSuccessfulLoad()
        capturingLoadingDelegate = CapturingHomepageLoadingDelegate()
        service.loadHomepage(delegate: capturingLoadingDelegate)
        capturingHomepageFeed.performUnsuccessfulLoad()

        XCTAssertFalse(capturingLoadingDelegate.didFinishLoadingInvoked)
    }

}
