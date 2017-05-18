//
//  WeasylHomepageFeedTests.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 16/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo
import XCTest

class WeasylHomepageFeedTests: XCTestCase {

    func testWhenToldToLoadTheHomepageURLIsRequested() {
        let expectedURL = URL(string: "https://www.weasyl.com/api/submissions/frontpage")!
        let capturingNetworkAdapter = CapturingNetworkAdapter()
        let service = WeasylService(networkAdapter: capturingNetworkAdapter)
        service.loadHomepage(delegate: DummyHomepageFeedDelegate())

        XCTAssertEqual(expectedURL, capturingNetworkAdapter.requestedURL)
    }

    func testTheDelegateIsToldTheFeedFailedToLoadWhenNetworkEncounteredError() {
        let failingNetworkAdapter = FailingNetworkAdapter()
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        let service = WeasylService(networkAdapter: failingNetworkAdapter)
        service.loadHomepage(delegate: capturingHomepageFeedDelegate)

        XCTAssertTrue(capturingHomepageFeedDelegate.wasNotifiedFeedDidFailToLoad)
    }

    func testTheDelegateIsNotToldAboutFeedFailuresUntilNetworkHandlerIsInvokedWithError() {
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        let blockedNetworkAdapter = BlockingNetworkAdapter(adapter: FailingNetworkAdapter())
        let service = WeasylService(networkAdapter: blockedNetworkAdapter)
        service.loadHomepage(delegate: capturingHomepageFeedDelegate)

        XCTAssertFalse(capturingHomepageFeedDelegate.wasNotifiedFeedDidFailToLoad)
    }

    func testWhenLoadingValidFeedDataTheDelegateIsToldTheFeedLoaded() {
        let successfulNetworkAdapter = SuccessfulNetworkAdapter(contentsOfJSONFile: "ValidWeasylHomepageResponse")
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        let service = WeasylService(networkAdapter: successfulNetworkAdapter)
        service.loadHomepage(delegate: capturingHomepageFeedDelegate)

        XCTAssertTrue(capturingHomepageFeedDelegate.wasNotifiedDidFinishLoading)
    }

    func testTheDelegateIsNotToldAboutFeedLoadsUntilNetworkHandlerIsInvokedWithData() {
        let blockedNetworkAdapter = BlockingNetworkAdapter(adapter: SuccessfulNetworkAdapter(contentsOfJSONFile: "ValidWeasylHomepageResponse"))
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        let service = WeasylService(networkAdapter: blockedNetworkAdapter)
        service.loadHomepage(delegate: capturingHomepageFeedDelegate)

        XCTAssertFalse(capturingHomepageFeedDelegate.wasNotifiedDidFinishLoading)
    }

    func testTheDelegateIsNotToldAboutFeedLoadsWhenNetworkErrors() {
        let successfulNetworkAdapter = FailingNetworkAdapter()
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        let service = WeasylService(networkAdapter: successfulNetworkAdapter)
        service.loadHomepage(delegate: capturingHomepageFeedDelegate)

        XCTAssertFalse(capturingHomepageFeedDelegate.wasNotifiedDidFinishLoading)
    }

    func testTheDelegateIsNotToldAboutFeedErrorsWhenNetworkSucceeds() {
        let blockedNetworkAdapter = SuccessfulNetworkAdapter(contentsOfJSONFile: "ValidWeasylHomepageResponse")
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        let service = WeasylService(networkAdapter: blockedNetworkAdapter)
        service.loadHomepage(delegate: capturingHomepageFeedDelegate)

        XCTAssertFalse(capturingHomepageFeedDelegate.wasNotifiedFeedDidFailToLoad)
    }

    func testNetworkRespondsWithInvalidJSONNotifiesDelegateAboutError() {
        let invalidJSONAdapter = SuccessfulNetworkAdapter(contentsOfJSONFile: "MalformedWeasylHomepageResponse")
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        let service = WeasylService(networkAdapter: invalidJSONAdapter)
        service.loadHomepage(delegate: capturingHomepageFeedDelegate)

        XCTAssertTrue(capturingHomepageFeedDelegate.wasNotifiedFeedDidFailToLoad)
    }

    func testNetworkRespondsWithInvalidJSONDoesNotNotifyDelegateLoadWasSuccessful() {
        let invalidJSONAdapter = SuccessfulNetworkAdapter(contentsOfJSONFile: "MalformedWeasylHomepageResponse")
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        let service = WeasylService(networkAdapter: invalidJSONAdapter)
        service.loadHomepage(delegate: capturingHomepageFeedDelegate)

        XCTAssertFalse(capturingHomepageFeedDelegate.wasNotifiedDidFinishLoading)
    }

    func testNetworkRespondsWithJSONThatDoesNotContainExpectedTopLevelStructureTellsDelegateLoadFailed() {
        let unexpectedStructure = ["key": "value"]
        let json = try! JSONSerialization.data(withJSONObject: unexpectedStructure, options: .prettyPrinted)
        let unexpectedJSONAdapter = SuccessfulNetworkAdapter(data: json)
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        let service = WeasylService(networkAdapter: unexpectedJSONAdapter)
        service.loadHomepage(delegate: capturingHomepageFeedDelegate)

        XCTAssertTrue(capturingHomepageFeedDelegate.wasNotifiedFeedDidFailToLoad)
    }

    func testParsingValidJSONProvidesFirstItemWithExpectedTitle() {
        let titleForFirstItemInJSON = ":CO: ChaiFennec"
        let validHomepageAdapter = SuccessfulNetworkAdapter(contentsOfJSONFile: "ValidWeasylHomepageResponse")
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        let service = WeasylService(networkAdapter: validHomepageAdapter)
        service.loadHomepage(delegate: capturingHomepageFeedDelegate)

        XCTAssertEqual(titleForFirstItemInJSON, capturingHomepageFeedDelegate.capturedResults?.first?.title)
    }

    func testParsingValidJSONProvidesSecondItemWithExpectedTitle() {
        let titleForSecondItemInJSON = "[C] Azri Simple Icon"
        let validHomepageAdapter = SuccessfulNetworkAdapter(contentsOfJSONFile: "ValidWeasylHomepageResponse")
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        let service = WeasylService(networkAdapter: validHomepageAdapter)
        service.loadHomepage(delegate: capturingHomepageFeedDelegate)

        guard let results = capturingHomepageFeedDelegate.capturedResults, results.count > 1 else {
            XCTFail()
            return
        }

        XCTAssertEqual(titleForSecondItemInJSON, results[1].title)
    }

    func testParsingValidJSONProvidesFirstItemWithExpectedContentIdentifier() {
        let contentIdentifierForFirstItemInJSON = "1489775"
        let validHomepageAdapter = SuccessfulNetworkAdapter(contentsOfJSONFile: "ValidWeasylHomepageResponse")
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        let service = WeasylService(networkAdapter: validHomepageAdapter)
        service.loadHomepage(delegate: capturingHomepageFeedDelegate)

        XCTAssertEqual(contentIdentifierForFirstItemInJSON, capturingHomepageFeedDelegate.capturedResults?.first?.contentIdentifier)
    }

    func testParsingValidJSONProvidesSecondItemWithExpectedContentIdentifier() {
        let contentIdentifierForSecondItemInJSON = "1489774"
        let validHomepageAdapter = SuccessfulNetworkAdapter(contentsOfJSONFile: "ValidWeasylHomepageResponse")
        let capturingHomepageFeedDelegate = CapturingHomepageFeedDelegate()
        let service = WeasylService(networkAdapter: validHomepageAdapter)
        service.loadHomepage(delegate: capturingHomepageFeedDelegate)

        guard let results = capturingHomepageFeedDelegate.capturedResults, results.count > 1 else {
            XCTFail()
            return
        }

        XCTAssertEqual(contentIdentifierForSecondItemInJSON, results[1].contentIdentifier)
    }

}
