//
//  InkbunnyAPIAdapterTests.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 20/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo
import XCTest

protocol InkbunnyAPIProtocol {

    func loadHomepage(completionHandler: @escaping (InkbunnyHomepageLoadResult) -> Void)

}

class CapturingInkbunnyAPI: InkbunnyAPIProtocol {

    private(set) var didLoadHomepage = false
    func loadHomepage(completionHandler: @escaping (InkbunnyHomepageLoadResult) -> Void) {
        didLoadHomepage = true
    }

}

struct SuccessfulInkbunnyAPI: InkbunnyAPIProtocol {

    func loadHomepage(completionHandler: @escaping (InkbunnyHomepageLoadResult) -> Void) {
        completionHandler(.success([]))
    }

}

struct FailingInkbunnyAPI: InkbunnyAPIProtocol {

    func loadHomepage(completionHandler: @escaping (InkbunnyHomepageLoadResult) -> Void) {
        completionHandler(.failure)
    }

}

struct InkbunnyAPIAdapter: HomepageFeed {

    var api: InkbunnyAPIProtocol

    init(api: InkbunnyAPIProtocol) {
        self.api = api
    }

    func loadFeed(delegate: HomepageFeedDelegate) {
        api.loadHomepage { result in
            switch result {
            case .failure:
                delegate.feedDidFailToLoad()

            default:
                break
            }

            delegate.feedDidFinishLoading(items: [])
        }
    }

}

class InkbunnyAPIAdapterTests: XCTestCase {

    func testFetchingHomepageShouldTellAPIToFetchHomepage() {
        let capturingInkbunnyAPI = CapturingInkbunnyAPI()
        let adapter = InkbunnyAPIAdapter(api: capturingInkbunnyAPI)
        adapter.loadFeed(delegate: DummyHomepageFeedDelegate())

        XCTAssertTrue(capturingInkbunnyAPI.didLoadHomepage)
    }

    func testSuccessfullyLoadingHomepageTellsDelegateFeedFinishedLoading() {
        let successfulInkbunnyAPI = SuccessfulInkbunnyAPI()
        let adapter = InkbunnyAPIAdapter(api: successfulInkbunnyAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertTrue(capturingHomepageFeedDelegate.wasNotifiedDidFinishLoading)
    }

    func testFailingToLoadHomepageTellDelegateFeedFailedToLoad() {
        let failingInkbunnyAPI = FailingInkbunnyAPI()
        let adapter = InkbunnyAPIAdapter(api: failingInkbunnyAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertTrue(capturingHomepageFeedDelegate.wasNotifiedFeedDidFailToLoad)
    }

    func testSuccessfullyLoadingHomepageDoesNotTellDelegateFeedFailedToLoad() {
        let successfulInkbunnyAPI = SuccessfulInkbunnyAPI()
        let adapter = InkbunnyAPIAdapter(api: successfulInkbunnyAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertFalse(capturingHomepageFeedDelegate.wasNotifiedFeedDidFailToLoad)
    }

}
