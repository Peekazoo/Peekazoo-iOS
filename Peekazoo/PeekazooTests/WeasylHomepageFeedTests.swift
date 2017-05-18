//
//  WeasylHomepageFeedTests.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 16/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo
import XCTest

class CapturingWeasylHomepageHandler {

    private(set) var wasNotifiedDidFinishLoading = false
    private(set) var capturedResults: [WeasylHomepageItem]?
    private(set) var wasNotifiedFeedDidFailToLoad = false
    func verify(_ result: WeasylHomepageLoadResult) {
        switch result {
        case .success(let items):
            wasNotifiedDidFinishLoading = true
            capturedResults = items
        case .failure:
            wasNotifiedFeedDidFailToLoad = true
        }
    }

}

class WeasylHomepageFeedTests: XCTestCase {

    func testWhenToldToLoadTheHomepageURLIsRequested() {
        let expectedURL = URL(string: "https://www.weasyl.com/api/submissions/frontpage")!
        let capturingNetworkAdapter = CapturingNetworkAdapter()
        let service = WeasylService(networkAdapter: capturingNetworkAdapter)
        service.loadHomepage(completionHandler: { _ in })

        XCTAssertEqual(expectedURL, capturingNetworkAdapter.requestedURL)
    }

    func testTheDelegateIsToldTheFeedFailedToLoadWhenNetworkEncounteredError() {
        let failingNetworkAdapter = FailingNetworkAdapter()
        let capturingHomepageHandler = CapturingWeasylHomepageHandler()
        let service = WeasylService(networkAdapter: failingNetworkAdapter)
        service.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertTrue(capturingHomepageHandler.wasNotifiedFeedDidFailToLoad)
    }

    func testTheDelegateIsNotToldAboutFeedFailuresUntilNetworkHandlerIsInvokedWithError() {
        let capturingHomepageHandler = CapturingWeasylHomepageHandler()
        let blockedNetworkAdapter = BlockingNetworkAdapter(adapter: FailingNetworkAdapter())
        let service = WeasylService(networkAdapter: blockedNetworkAdapter)
        service.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertFalse(capturingHomepageHandler.wasNotifiedFeedDidFailToLoad)
    }

    func testWhenLoadingValidFeedDataTheDelegateIsToldTheFeedLoaded() {
        let successfulNetworkAdapter = SuccessfulNetworkAdapter(contentsOfJSONFile: "ValidWeasylHomepageResponse")
        let capturingHomepageHandler = CapturingWeasylHomepageHandler()
        let service = WeasylService(networkAdapter: successfulNetworkAdapter)
        service.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertTrue(capturingHomepageHandler.wasNotifiedDidFinishLoading)
    }

    func testTheDelegateIsNotToldAboutFeedLoadsUntilNetworkHandlerIsInvokedWithData() {
        let blockedNetworkAdapter = BlockingNetworkAdapter(adapter: SuccessfulNetworkAdapter(contentsOfJSONFile: "ValidWeasylHomepageResponse"))
        let capturingHomepageHandler = CapturingWeasylHomepageHandler()
        let service = WeasylService(networkAdapter: blockedNetworkAdapter)
        service.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertFalse(capturingHomepageHandler.wasNotifiedDidFinishLoading)
    }

    func testTheDelegateIsNotToldAboutFeedLoadsWhenNetworkErrors() {
        let successfulNetworkAdapter = FailingNetworkAdapter()
        let capturingHomepageHandler = CapturingWeasylHomepageHandler()
        let service = WeasylService(networkAdapter: successfulNetworkAdapter)
        service.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertFalse(capturingHomepageHandler.wasNotifiedDidFinishLoading)
    }

    func testTheDelegateIsNotToldAboutFeedErrorsWhenNetworkSucceeds() {
        let blockedNetworkAdapter = SuccessfulNetworkAdapter(contentsOfJSONFile: "ValidWeasylHomepageResponse")
        let capturingHomepageHandler = CapturingWeasylHomepageHandler()
        let service = WeasylService(networkAdapter: blockedNetworkAdapter)
        service.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertFalse(capturingHomepageHandler.wasNotifiedFeedDidFailToLoad)
    }

    func testNetworkRespondsWithInvalidJSONNotifiesDelegateAboutError() {
        let invalidJSONAdapter = SuccessfulNetworkAdapter(contentsOfJSONFile: "MalformedWeasylHomepageResponse")
        let capturingHomepageHandler = CapturingWeasylHomepageHandler()
        let service = WeasylService(networkAdapter: invalidJSONAdapter)
        service.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertTrue(capturingHomepageHandler.wasNotifiedFeedDidFailToLoad)
    }

    func testNetworkRespondsWithInvalidJSONDoesNotNotifyDelegateLoadWasSuccessful() {
        let invalidJSONAdapter = SuccessfulNetworkAdapter(contentsOfJSONFile: "MalformedWeasylHomepageResponse")
        let capturingHomepageHandler = CapturingWeasylHomepageHandler()
        let service = WeasylService(networkAdapter: invalidJSONAdapter)
        service.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertFalse(capturingHomepageHandler.wasNotifiedDidFinishLoading)
    }

    func testNetworkRespondsWithJSONThatDoesNotContainExpectedTopLevelStructureTellsDelegateLoadFailed() {
        let unexpectedStructure = ["key": "value"]
        let json = try! JSONSerialization.data(withJSONObject: unexpectedStructure, options: .prettyPrinted)
        let unexpectedJSONAdapter = SuccessfulNetworkAdapter(data: json)
        let capturingHomepageHandler = CapturingWeasylHomepageHandler()
        let service = WeasylService(networkAdapter: unexpectedJSONAdapter)
        service.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertTrue(capturingHomepageHandler.wasNotifiedFeedDidFailToLoad)
    }

    func testParsingValidJSONProvidesFirstItemWithExpectedTitle() {
        let titleForFirstItemInJSON = ":CO: ChaiFennec"
        let validHomepageAdapter = SuccessfulNetworkAdapter(contentsOfJSONFile: "ValidWeasylHomepageResponse")
        let capturingHomepageHandler = CapturingWeasylHomepageHandler()
        let service = WeasylService(networkAdapter: validHomepageAdapter)
        service.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertEqual(titleForFirstItemInJSON, capturingHomepageHandler.capturedResults?.first?.title)
    }

    func testParsingValidJSONProvidesSecondItemWithExpectedTitle() {
        let titleForSecondItemInJSON = "[C] Azri Simple Icon"
        let validHomepageAdapter = SuccessfulNetworkAdapter(contentsOfJSONFile: "ValidWeasylHomepageResponse")
        let capturingHomepageHandler = CapturingWeasylHomepageHandler()
        let service = WeasylService(networkAdapter: validHomepageAdapter)
        service.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        guard let results = capturingHomepageHandler.capturedResults, results.count > 1 else {
            XCTFail()
            return
        }

        XCTAssertEqual(titleForSecondItemInJSON, results[1].title)
    }

    func testParsingValidJSONProvidesFirstItemWithExpectedContentIdentifier() {
        let contentIdentifierForFirstItemInJSON = "1489775"
        let validHomepageAdapter = SuccessfulNetworkAdapter(contentsOfJSONFile: "ValidWeasylHomepageResponse")
        let capturingHomepageHandler = CapturingWeasylHomepageHandler()
        let service = WeasylService(networkAdapter: validHomepageAdapter)
        service.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertEqual(contentIdentifierForFirstItemInJSON, capturingHomepageHandler.capturedResults?.first?.contentIdentifier)
    }

    func testParsingValidJSONProvidesSecondItemWithExpectedContentIdentifier() {
        let contentIdentifierForSecondItemInJSON = "1489774"
        let validHomepageAdapter = SuccessfulNetworkAdapter(contentsOfJSONFile: "ValidWeasylHomepageResponse")
        let capturingHomepageHandler = CapturingWeasylHomepageHandler()
        let service = WeasylService(networkAdapter: validHomepageAdapter)
        service.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        guard let results = capturingHomepageHandler.capturedResults, results.count > 1 else {
            XCTFail()
            return
        }

        XCTAssertEqual(contentIdentifierForSecondItemInJSON, results[1].contentIdentifier)
    }

}
