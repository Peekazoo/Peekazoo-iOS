//
//  InkbunnyHomepageAdapterTests.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 20/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Peekazoo
import XCTest

class InkbunnyHomepageAdapterTests: XCTestCase {

    func testFetchingHomepageShouldTellAPIToFetchHomepage() {
        let capturingInkbunnyAPI = CapturingInkbunnyAPI()
        let adapter = InkbunnyHomepageAdapter(api: capturingInkbunnyAPI)
        adapter.loadFeed(delegate: DummyHomepageFeedDelegate())

        XCTAssertTrue(capturingInkbunnyAPI.didLoadHomepage)
    }

    func testSuccessfullyLoadingHomepageTellsDelegateFeedFinishedLoading() {
        let successfulInkbunnyAPI = SuccessfulInkbunnyAPI()
        let adapter = InkbunnyHomepageAdapter(api: successfulInkbunnyAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertTrue(capturingHomepageFeedDelegate.wasNotifiedDidFinishLoading)
    }

    func testFailingToLoadHomepageTellDelegateFeedFailedToLoad() {
        let failingInkbunnyAPI = FailingInkbunnyAPI()
        let adapter = InkbunnyHomepageAdapter(api: failingInkbunnyAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertTrue(capturingHomepageFeedDelegate.wasNotifiedFeedDidFailToLoad)
    }

    func testSuccessfullyLoadingHomepageDoesNotTellDelegateFeedFailedToLoad() {
        let successfulInkbunnyAPI = SuccessfulInkbunnyAPI()
        let adapter = InkbunnyHomepageAdapter(api: successfulInkbunnyAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertFalse(capturingHomepageFeedDelegate.wasNotifiedFeedDidFailToLoad)
    }

    func testFailingToLoadHomepageDoesNotTellDelegateFeedFinishedLoading() {
        let failingInkbunnyAPI = FailingInkbunnyAPI()
        let adapter = InkbunnyHomepageAdapter(api: failingInkbunnyAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertFalse(capturingHomepageFeedDelegate.wasNotifiedDidFinishLoading)
    }

    func testSuccessfullyLoadingHomepageAdaptsTitleInFirstItem() {
        let title = "Some content"
        let stubInkbunnySubmissionImpl = StubInkbunnySubmission(title: title)
        let successfulInkbunnyAPI = SuccessfulInkbunnyAPI(items: [stubInkbunnySubmissionImpl])
        let adapter = InkbunnyHomepageAdapter(api: successfulInkbunnyAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertEqual(title, capturingHomepageFeedDelegate.capturedResults?.first?.title)
    }

    func testSuccessfullyLoadingHomepageAdaptsSubmissionIdentifierInFirstItem() {
        let submissionID = "Some identifier"
        let stubInkbunnySubmissionImpl = StubInkbunnySubmission(submissionID: submissionID)
        let successfulInkbunnyAPI = SuccessfulInkbunnyAPI(items: [stubInkbunnySubmissionImpl])
        let adapter = InkbunnyHomepageAdapter(api: successfulInkbunnyAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertEqual(submissionID, capturingHomepageFeedDelegate.capturedResults?.first?.contentIdentifier)
    }

    func testSuccessfullyLoadingMultipleItemsShouldTheSecondIdentifier() {
        let firstInkbunnySubmissionImpl = StubInkbunnySubmission(submissionID: "ID 1")
        let secondInkbunnySubmissionImpl = StubInkbunnySubmission(submissionID: "ID 2")
        let successfulInkbunnyAPI = SuccessfulInkbunnyAPI(items: [firstInkbunnySubmissionImpl, secondInkbunnySubmissionImpl])
        let adapter = InkbunnyHomepageAdapter(api: successfulInkbunnyAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertEqual(secondInkbunnySubmissionImpl.submissionID, capturingHomepageFeedDelegate.result(at: 1)?.contentIdentifier)
    }

    func testSuccessfullyLoadingItemShouldAdaptPostedDate() {
        let postedDate = Date(timeIntervalSinceNow: -7200)
        let stubInkbunnySubmissionImpl = StubInkbunnySubmission(postedDate: postedDate)
        let successfulInkbunnyAPI = SuccessfulInkbunnyAPI(items: [stubInkbunnySubmissionImpl])
        let adapter = InkbunnyHomepageAdapter(api: successfulInkbunnyAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertEqual(postedDate, capturingHomepageFeedDelegate.capturedResults?.first?.creationDate)
    }

}
