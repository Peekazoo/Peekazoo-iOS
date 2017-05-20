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

    var items: [InkbunnySubmission]

    init(items: [InkbunnySubmission] = []) {
        self.items = items
    }

    func loadHomepage(completionHandler: @escaping (InkbunnyHomepageLoadResult) -> Void) {
        completionHandler(.success(items))
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
            case .success(let items):
                delegate.feedDidFinishLoading(items: self.adapt(items: items))

            case .failure:
                delegate.feedDidFailToLoad()
            }
        }
    }

    private func adapt(items: [InkbunnySubmission]) -> [AdaptedItem] {
        guard let item = items.first else { return [] }
        return [AdaptedItem(submission: item)]
    }

    private struct AdaptedItem: HomepageItem {

        private var submission: InkbunnySubmission
        var title: String { return submission.title }
        var contentIdentifier: String = ""

        init(submission: InkbunnySubmission) {
            self.submission = submission
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

    func testFailingToLoadHomepageDoesNotTellDelegateFeedFinishedLoading() {
        let failingInkbunnyAPI = FailingInkbunnyAPI()
        let adapter = InkbunnyAPIAdapter(api: failingInkbunnyAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertFalse(capturingHomepageFeedDelegate.wasNotifiedDidFinishLoading)
    }

    func testSuccessfullyLoadingHomepageAdaptsTitleInFirstItem() {
        let title = "Some content"
        let stubInkbunnySubmission = InkbunnySubmission(submissionID: "", title: title)
        let successfulInkbunnyAPI = SuccessfulInkbunnyAPI(items: [stubInkbunnySubmission])
        let adapter = InkbunnyAPIAdapter(api: successfulInkbunnyAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertEqual(title, capturingHomepageFeedDelegate.capturedResults?.first?.title)
    }

}
