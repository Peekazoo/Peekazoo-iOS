//
//  InkbunnyAPIAdapterTests.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 20/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Peekazoo
import XCTest

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

    func testSuccessfullyLoadingHomepageAdaptsSubmissionIdentifierInFirstItem() {
        let submissionID = "Some identifier"
        let stubInkbunnySubmission = InkbunnySubmission(submissionID: submissionID, title: "")
        let successfulInkbunnyAPI = SuccessfulInkbunnyAPI(items: [stubInkbunnySubmission])
        let adapter = InkbunnyAPIAdapter(api: successfulInkbunnyAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertEqual(submissionID, capturingHomepageFeedDelegate.capturedResults?.first?.contentIdentifier)
    }

    func testSuccessfullyLoadingMultipleItemsShouldTheSecondIdentifier() {
        let firstInkbunnySubmission = InkbunnySubmission(submissionID: "ID 1", title: "")
        let secondInkbunnySubmission = InkbunnySubmission(submissionID: "ID 2", title: "")
        let successfulInkbunnyAPI = SuccessfulInkbunnyAPI(items: [firstInkbunnySubmission, secondInkbunnySubmission])
        let adapter = InkbunnyAPIAdapter(api: successfulInkbunnyAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertEqual(secondInkbunnySubmission.submissionID, capturingHomepageFeedDelegate.result(at: 1)?.contentIdentifier)
    }

    func testSuccessfullyLoadingItemShouldAdaptPostedDate() {
        let postedDate = Date(timeIntervalSinceNow: -7200)
        let stubInkbunnySubmission = InkbunnySubmission(submissionID: "", title: "", postedDate: postedDate)
        let successfulInkbunnyAPI = SuccessfulInkbunnyAPI(items: [stubInkbunnySubmission])
        let adapter = InkbunnyAPIAdapter(api: successfulInkbunnyAPI)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        adapter.loadFeed(delegate: capturingHomepageFeedDelegate)

        XCTAssertEqual(postedDate, capturingHomepageFeedDelegate.capturedResults?.first?.creationDate)
    }

}
