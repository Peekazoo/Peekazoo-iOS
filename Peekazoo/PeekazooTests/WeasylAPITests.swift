//
//  WeasylAPITests.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 16/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Peekazoo
import XCTest

class CapturingWeasylHomepageHandler {

    private(set) var wasNotifiedDidFinishLoading = false
    private(set) var capturedResults: [WeasylSubmission]?
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

    func result(at index: Int) -> WeasylSubmission? {
        guard let results = capturedResults, index < results.count else {
            return nil
        }

        return results[index]
    }

}

class WeasylAPITests: XCTestCase {

    private func makeValidHomepageNetworkAdapter() -> NetworkAdapter {
        return SuccessfulNetworkAdapter(contentsOfJSONFile: "ValidWeasylHomepageResponse")
    }

    private func makeMalformedHomepageNetworkAdapter() -> NetworkAdapter {
        return SuccessfulNetworkAdapter(contentsOfJSONFile: "MalformedWeasylHomepageResponse")
    }

    func testWhenToldToLoadTheHomepageURLIsRequested() {
        let expectedURL = URL(string: "https://www.weasyl.com/api/submissions/frontpage")!
        let capturingNetworkAdapter = CapturingNetworkAdapter()
        let weasylAPI = WeasylAPI(networkAdapter: capturingNetworkAdapter)
        weasylAPI.loadHomepage(completionHandler: { _ in })

        XCTAssertEqual(expectedURL, capturingNetworkAdapter.requestedURL)
    }

    func testTheDelegateIsToldTheFeedFailedToLoadWhenNetworkEncounteredError() {
        let failingNetworkAdapter = FailingNetworkAdapter()
        let capturingHomepageHandler = CapturingWeasylHomepageHandler()
        let weasylAPI = WeasylAPI(networkAdapter: failingNetworkAdapter)
        weasylAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertTrue(capturingHomepageHandler.wasNotifiedFeedDidFailToLoad)
    }

    func testTheDelegateIsNotToldAboutFeedFailuresUntilNetworkHandlerIsInvokedWithError() {
        let capturingHomepageHandler = CapturingWeasylHomepageHandler()
        let blockedNetworkAdapter = BlockingNetworkAdapter(adapter: FailingNetworkAdapter())
        let weasylAPI = WeasylAPI(networkAdapter: blockedNetworkAdapter)
        weasylAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertFalse(capturingHomepageHandler.wasNotifiedFeedDidFailToLoad)
    }

    func testWhenLoadingValidFeedDataTheDelegateIsToldTheFeedLoaded() {
        let successfulNetworkAdapter = makeValidHomepageNetworkAdapter()
        let capturingHomepageHandler = CapturingWeasylHomepageHandler()
        let weasylAPI = WeasylAPI(networkAdapter: successfulNetworkAdapter)
        weasylAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertTrue(capturingHomepageHandler.wasNotifiedDidFinishLoading)
    }

    func testTheDelegateIsNotToldAboutFeedLoadsUntilNetworkHandlerIsInvokedWithData() {
        let blockedNetworkAdapter = BlockingNetworkAdapter(adapter: makeValidHomepageNetworkAdapter())
        let capturingHomepageHandler = CapturingWeasylHomepageHandler()
        let weasylAPI = WeasylAPI(networkAdapter: blockedNetworkAdapter)
        weasylAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertFalse(capturingHomepageHandler.wasNotifiedDidFinishLoading)
    }

    func testTheDelegateIsNotToldAboutFeedLoadsWhenNetworkErrors() {
        let successfulNetworkAdapter = FailingNetworkAdapter()
        let capturingHomepageHandler = CapturingWeasylHomepageHandler()
        let weasylAPI = WeasylAPI(networkAdapter: successfulNetworkAdapter)
        weasylAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertFalse(capturingHomepageHandler.wasNotifiedDidFinishLoading)
    }

    func testTheDelegateIsNotToldAboutFeedErrorsWhenNetworkSucceeds() {
        let blockedNetworkAdapter = makeValidHomepageNetworkAdapter()
        let capturingHomepageHandler = CapturingWeasylHomepageHandler()
        let weasylAPI = WeasylAPI(networkAdapter: blockedNetworkAdapter)
        weasylAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertFalse(capturingHomepageHandler.wasNotifiedFeedDidFailToLoad)
    }

    func testNetworkRespondsWithInvalidJSONNotifiesDelegateAboutError() {
        let invalidJSONAdapter = makeMalformedHomepageNetworkAdapter()
        let capturingHomepageHandler = CapturingWeasylHomepageHandler()
        let weasylAPI = WeasylAPI(networkAdapter: invalidJSONAdapter)
        weasylAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertTrue(capturingHomepageHandler.wasNotifiedFeedDidFailToLoad)
    }

    func testNetworkRespondsWithInvalidJSONDoesNotNotifyDelegateLoadWasSuccessful() {
        let invalidJSONAdapter = makeMalformedHomepageNetworkAdapter()
        let capturingHomepageHandler = CapturingWeasylHomepageHandler()
        let weasylAPI = WeasylAPI(networkAdapter: invalidJSONAdapter)
        weasylAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertFalse(capturingHomepageHandler.wasNotifiedDidFinishLoading)
    }

    func testNetworkRespondsWithJSONThatDoesNotContainExpectedTopLevelStructureTellsDelegateLoadFailed() {
        let unexpectedStructure = ["key": "value"]
        let json = try! JSONSerialization.data(withJSONObject: unexpectedStructure, options: .prettyPrinted)
        let unexpectedJSONAdapter = SuccessfulNetworkAdapter(data: json)
        let capturingHomepageHandler = CapturingWeasylHomepageHandler()
        let weasylAPI = WeasylAPI(networkAdapter: unexpectedJSONAdapter)
        weasylAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertTrue(capturingHomepageHandler.wasNotifiedFeedDidFailToLoad)
    }

    func testParsingValidJSONProvidesFirstItemWithExpectedTitle() {
        let titleForFirstItemInJSON = ":CO: ChaiFennec"
        let validHomepageAdapter = makeValidHomepageNetworkAdapter()
        let capturingHomepageHandler = CapturingWeasylHomepageHandler()
        let weasylAPI = WeasylAPI(networkAdapter: validHomepageAdapter)
        weasylAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertEqual(titleForFirstItemInJSON, capturingHomepageHandler.result(at: 0)?.title)
    }

    func testParsingValidJSONProvidesSecondItemWithExpectedTitle() {
        let titleForSecondItemInJSON = "[C] Azri Simple Icon"
        let validHomepageAdapter = makeValidHomepageNetworkAdapter()
        let capturingHomepageHandler = CapturingWeasylHomepageHandler()
        let weasylAPI = WeasylAPI(networkAdapter: validHomepageAdapter)
        weasylAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertEqual(titleForSecondItemInJSON, capturingHomepageHandler.result(at: 1)?.title)
    }

    func testParsingValidJSONProvidesFirstItemWithExpectedContentIdentifier() {
        let submitIDForFirstItem = "1489775"
        let validHomepageAdapter = makeValidHomepageNetworkAdapter()
        let capturingHomepageHandler = CapturingWeasylHomepageHandler()
        let weasylAPI = WeasylAPI(networkAdapter: validHomepageAdapter)
        weasylAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertEqual(submitIDForFirstItem, capturingHomepageHandler.result(at: 0)?.submitID)
    }

    func testParsingValidJSONProvidesSecondItemWithExpectedContentIdentifier() {
        let submitIDForSecondItem = "1489774"
        let validHomepageAdapter = makeValidHomepageNetworkAdapter()
        let capturingHomepageHandler = CapturingWeasylHomepageHandler()
        let weasylAPI = WeasylAPI(networkAdapter: validHomepageAdapter)
        weasylAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertEqual(submitIDForSecondItem, capturingHomepageHandler.result(at: 1)?.submitID)
    }

}
