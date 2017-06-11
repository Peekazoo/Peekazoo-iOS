//
//  InkbunnyAPITests.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 19/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Peekazoo
import XCTest

class CapturingInkbunnyHomepageHandler {

    private(set) var wasNotifiedFeedDidFailToLoad = false
    private(set) var wasNotifiedFeedLoaded = false
    private(set) var results: [InkbunnySubmission]?
    func verify(_ result: InkbunnyHomepageLoadResult) {
        switch result {
        case .success(let results):
            self.results = results
            wasNotifiedFeedLoaded = true

        case .failure:
            wasNotifiedFeedDidFailToLoad = true
        }
    }

    func result(at index: Int) -> InkbunnySubmission? {
        guard let results = results, index < results.count else { return nil }
        return results[index]
    }

}

class InkbunnyAPITests: XCTestCase {

    let expectedLoginURL = URL(string: "https://inkbunny.net/api_login.php?username=guest&password=")!

    private func makeValidLoginNetworkAdapter() -> ControllableNetworkAdapter {
        var loginNetworkAdapter = ControllableNetworkAdapter()
        loginNetworkAdapter.stub(url: expectedLoginURL,
                                 withContentsOfJSONFile: "ValidInkbunnyGuestLoginResponse")

        return loginNetworkAdapter
    }

    private func makeSuccessfulSearchNetworkAdapter() -> ControllableNetworkAdapter {
        var successfulNetworkAdapter = makeValidLoginNetworkAdapter()
        successfulNetworkAdapter.stub(url: URL(string: "https://inkbunny.net/api_search.php?sid=This_Is_A_Test_Token")!,
                                      withContentsOfJSONFile: "ValidInkbunnySearchResponse")

        return successfulNetworkAdapter
    }

    private func makeFailingSearchNetworkAdapter() -> ControllableNetworkAdapter {
        var failingSearchNetworkAdapter = makeValidLoginNetworkAdapter()
        failingSearchNetworkAdapter.stubFailure(url: URL(string: "https://inkbunny.net/api_search.php?sid=This_Is_A_Test_Token")!)

        return failingSearchNetworkAdapter
    }

    func testAttemptingToFetchHomepageWhenNotLoggedInGetsLoginEndpoint() {
        let capturingNetworkAdapter = CapturingNetworkAdapter()
        let inkbunnyAPI = JSONInkbunnyAPI(networkAdapter: capturingNetworkAdapter)
        inkbunnyAPI.loadHomepage(completionHandler: { _ in })

        XCTAssertEqual(expectedLoginURL, capturingNetworkAdapter.requestedURL)
    }

    func testAttemptingToFetchHomepageWhereGuestLoginFailsInvokesHandlerWithFailure() {
        let capturingNetworkAdapter = FailingNetworkAdapter()
        let inkbunnyAPI = JSONInkbunnyAPI(networkAdapter: capturingNetworkAdapter)
        let capturingHomepageHandler = CapturingInkbunnyHomepageHandler()
        inkbunnyAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertTrue(capturingHomepageHandler.wasNotifiedFeedDidFailToLoad)
    }

    func testHandlerNotInvokedWhenLoginFailsUntilNetworkResponds() {
        let blockingNetworkAdapter = BlockingNetworkAdapter(adapter: FailingNetworkAdapter())
        let inkbunnyAPI = JSONInkbunnyAPI(networkAdapter: blockingNetworkAdapter)
        let capturingHomepageHandler = CapturingInkbunnyHomepageHandler()
        inkbunnyAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertFalse(capturingHomepageHandler.wasNotifiedFeedDidFailToLoad)
    }

    func testLoginRequestReturnsValidResponseRequestsSearchEndpoint() {
        let expectedSearchEndpoint = URL(string: "https://inkbunny.net/api_search.php")!
        let successfulNetworkAdapter = makeValidLoginNetworkAdapter()
        let journallingNetworkAdapter = JournallingNetworkAdapter(networkAdapter: successfulNetworkAdapter)
        let inkbunnyAPI = JSONInkbunnyAPI(networkAdapter: journallingNetworkAdapter)
        let capturingHomepageHandler = CapturingInkbunnyHomepageHandler()
        inkbunnyAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertTrue(journallingNetworkAdapter.lastGetURLContains(expectedSearchEndpoint.absoluteString))
    }

    func testLoginRequestReturnsValidResponseDoesNotNotifyHandlerAboutFailure() {
        let validLoginNetworkAdapter = makeValidLoginNetworkAdapter()
        let inkbunnyAPI = JSONInkbunnyAPI(networkAdapter: validLoginNetworkAdapter)
        let capturingHomepageHandler = CapturingInkbunnyHomepageHandler()
        inkbunnyAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertFalse(capturingHomepageHandler.wasNotifiedFeedDidFailToLoad)
    }

    func testLoginReturnsInvalidResponseDoesNotAttemptToFetchFromSearchEndpoint() {
        let capturingNetworkAdapter = FailingNetworkAdapter()
        let journallingNetworkAdapter = JournallingNetworkAdapter(networkAdapter: capturingNetworkAdapter)
        let inkbunnyAPI = JSONInkbunnyAPI(networkAdapter: journallingNetworkAdapter)
        let capturingHomepageHandler = CapturingInkbunnyHomepageHandler()
        inkbunnyAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertFalse(journallingNetworkAdapter.lastGetURLContains("api_search.php"))
    }

    func testLoginReturnsInvalidJSONDataNotifiesHandlerOfFailure() {
        let invalidJSONNetworkAdapter = SuccessfulNetworkAdapter(string: "{what!")
        let inkbunnyAPI = JSONInkbunnyAPI(networkAdapter: invalidJSONNetworkAdapter)
        let capturingHomepageHandler = CapturingInkbunnyHomepageHandler()
        inkbunnyAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertTrue(capturingHomepageHandler.wasNotifiedFeedDidFailToLoad)
    }

    func testLoginReturnsValidJSONWithoutSidFieldNotifiesHandlerOfFailure() {
        let missingSidNetworkAdapter = SuccessfulNetworkAdapter(string: "{\"notsid\": \"value\"}")
        let inkbunnyAPI = JSONInkbunnyAPI(networkAdapter: missingSidNetworkAdapter)
        let capturingHomepageHandler = CapturingInkbunnyHomepageHandler()
        inkbunnyAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertTrue(capturingHomepageHandler.wasNotifiedFeedDidFailToLoad)
    }

    func testLoginReturnsValidJSONWithSidFieldUsesSidFieldForSearchRequest() {
        let sidFromJSON = "This_Is_A_Test_Token"
        let successfulLoginNetworkAdapter = SuccessfulNetworkAdapter(contentsOfJSONFile: "ValidInkbunnyGuestLoginResponse")
        let journallingNetworkAdapter = JournallingNetworkAdapter(networkAdapter: successfulLoginNetworkAdapter)
        let inkbunnyAPI = JSONInkbunnyAPI(networkAdapter: journallingNetworkAdapter)
        let capturingHomepageHandler = CapturingInkbunnyHomepageHandler()
        inkbunnyAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

         XCTAssertTrue(journallingNetworkAdapter.lastGetURLContains("api_search.php?sid=\(sidFromJSON)"))
    }

    func testSearchFailsAfterLoginSucceedsNotifiesHandlerOfFailure() {
        let controllableNetworkAdapter = makeFailingSearchNetworkAdapter()
        let inkbunnyAPI = JSONInkbunnyAPI(networkAdapter: controllableNetworkAdapter)
        let capturingHomepageHandler = CapturingInkbunnyHomepageHandler()
        inkbunnyAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertTrue(capturingHomepageHandler.wasNotifiedFeedDidFailToLoad)
    }

    func testSearchSucceedsWithInvalidJSONAfterGuestLoginSucceedsNotifiesHandlerOfFailure() {
        let failingSearchNetworkAdapter = makeFailingSearchNetworkAdapter()
        let inkbunnyAPI = JSONInkbunnyAPI(networkAdapter: failingSearchNetworkAdapter)
        let capturingHomepageHandler = CapturingInkbunnyHomepageHandler()
        inkbunnyAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertTrue(capturingHomepageHandler.wasNotifiedFeedDidFailToLoad)
    }

    func testSearchSucceedsWithValidJSONNotifiesHandlerOfSuccess() {
        let happyPathNetworkAdapter = makeSuccessfulSearchNetworkAdapter()
        let inkbunnyAPI = JSONInkbunnyAPI(networkAdapter: happyPathNetworkAdapter)
        let capturingHomepageHandler = CapturingInkbunnyHomepageHandler()
        inkbunnyAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertTrue(capturingHomepageHandler.wasNotifiedFeedLoaded)
    }

    func testLoginFailsDoesNotNotifyHandlerOfSuccess() {
        let capturingNetworkAdapter = FailingNetworkAdapter()
        let inkbunnyAPI = JSONInkbunnyAPI(networkAdapter: capturingNetworkAdapter)
        let capturingHomepageHandler = CapturingInkbunnyHomepageHandler()
        inkbunnyAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertFalse(capturingHomepageHandler.wasNotifiedFeedLoaded)
    }

    func testLoginSucceedsThenSearchFailsDoesNotNotifyHandlerOfSuccess() {
        let controllableNetworkAdapter = makeFailingSearchNetworkAdapter()
        let inkbunnyAPI = JSONInkbunnyAPI(networkAdapter: controllableNetworkAdapter)
        let capturingHomepageHandler = CapturingInkbunnyHomepageHandler()
        inkbunnyAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertFalse(capturingHomepageHandler.wasNotifiedFeedLoaded)
    }

    func testSearchSucceedsWithValidJSONDoesNotNotifyHandlerOfFailure() {
        let happyPathNetworkAdapter = makeSuccessfulSearchNetworkAdapter()
        let inkbunnyAPI = JSONInkbunnyAPI(networkAdapter: happyPathNetworkAdapter)
        let capturingHomepageHandler = CapturingInkbunnyHomepageHandler()
        inkbunnyAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertFalse(capturingHomepageHandler.wasNotifiedFeedDidFailToLoad)
    }

    func testSearchSucceedsProvidesHandlerWithItemConfiguredWithTitle() {
        let firstTitleInSearchJSON = "Green Batsu OTA (OPEN"
        let happyPathNetworkAdapter = makeSuccessfulSearchNetworkAdapter()
        let inkbunnyAPI = JSONInkbunnyAPI(networkAdapter: happyPathNetworkAdapter)
        let capturingHomepageHandler = CapturingInkbunnyHomepageHandler()
        inkbunnyAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertEqual(firstTitleInSearchJSON, capturingHomepageHandler.results?.first?.title)
    }

    func testSearchSucceedsProvidesHandlerWithSecondItemConfiguredWithTitle() {
        let secondTitleInSearchJSON = "Groot's Undies"
        let happyPathNetworkAdapter = makeSuccessfulSearchNetworkAdapter()
        let inkbunnyAPI = JSONInkbunnyAPI(networkAdapter: happyPathNetworkAdapter)
        let capturingHomepageHandler = CapturingInkbunnyHomepageHandler()
        inkbunnyAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertEqual(secondTitleInSearchJSON, capturingHomepageHandler.result(at: 1)?.title)
    }

    func testSearchSucceedsProvidesHandlerWithItemConfiguredWithSubmissionID() {
        let firstSubmissionIDInSearchJSON = "1359474"
        let happyPathNetworkAdapter = makeSuccessfulSearchNetworkAdapter()
        let inkbunnyAPI = JSONInkbunnyAPI(networkAdapter: happyPathNetworkAdapter)
        let capturingHomepageHandler = CapturingInkbunnyHomepageHandler()
        inkbunnyAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertEqual(firstSubmissionIDInSearchJSON, capturingHomepageHandler.results?.first?.submissionID)
    }

    func testSearchSucceedsProvidesHandlerWithSecondItemConfiguredWithSubmissionID() {
        let secondSubmissionIDInSearchJSON = "1359473"
        let happyPathNetworkAdapter = makeSuccessfulSearchNetworkAdapter()
        let inkbunnyAPI = JSONInkbunnyAPI(networkAdapter: happyPathNetworkAdapter)
        let capturingHomepageHandler = CapturingInkbunnyHomepageHandler()
        inkbunnyAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertEqual(secondSubmissionIDInSearchJSON, capturingHomepageHandler.result(at: 1)?.submissionID)
    }

    func testSearchRequestProvidesUnexpectedSubmissionsRootJSONTypeNotifiesHandlerOfFailure() {
        var unexpectedRootAdapter = makeValidLoginNetworkAdapter()
        let unexpectedRoot = "{\"submissions\": \"this should be an array\"}".data(using: .utf8)!
        let searchURL = URL(string: "https://inkbunny.net/api_search.php?sid=This_Is_A_Test_Token")!
        unexpectedRootAdapter.stub(url: searchURL, with: unexpectedRoot)
        let inkbunnyAPI = JSONInkbunnyAPI(networkAdapter: unexpectedRootAdapter)
        let capturingHomepageHandler = CapturingInkbunnyHomepageHandler()
        inkbunnyAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertTrue(capturingHomepageHandler.wasNotifiedFeedDidFailToLoad)
    }

    func testParsingPostedDateFromResponse() {
        let firstDateFromJSON = DateComponents(calendar: Calendar.current, timeZone: TimeZone(secondsFromGMT: 7200), year: 2017, month: 5, day: 19, hour: 21, minute: 46, second: 03, nanosecond: 561000110).date!
        let happyPathNetworkAdapter = makeSuccessfulSearchNetworkAdapter()
        let inkbunnyAPI = JSONInkbunnyAPI(networkAdapter: happyPathNetworkAdapter)
        let capturingHomepageHandler = CapturingInkbunnyHomepageHandler()
        inkbunnyAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertEqual(firstDateFromJSON, capturingHomepageHandler.result(at: 0)?.postedDate)
    }

    func testSearchSucceedsWithValidJSONWithUnexpectedDateFormatNotifiersHandlerOfFailure() {
        var invalidDateTypeNetworkAdapter = makeValidLoginNetworkAdapter()
        invalidDateTypeNetworkAdapter.stub(url: URL(string: "https://inkbunny.net/api_search.php?sid=This_Is_A_Test_Token")!,
                                      withContentsOfJSONFile: "InkbunnyInvalidSubmissionDateFormatSubmissionResponse")
        let inkbunnyAPI = JSONInkbunnyAPI(networkAdapter: invalidDateTypeNetworkAdapter)
        let capturingHomepageHandler = CapturingInkbunnyHomepageHandler()
        inkbunnyAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertTrue(capturingHomepageHandler.wasNotifiedFeedDidFailToLoad)
    }

}
