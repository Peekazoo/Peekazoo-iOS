//
//  InkbunnyAPITests.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 19/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo
import XCTest

enum InkbunnyHomepageLoadResult {
    case success([InkbunnyHomepageItem])
    case failure
}

struct InkbunnyHomepageItem {

    var title: String

}

struct InkbunnyAPI {

    var networkAdapter: NetworkAdapter

    init(networkAdapter: NetworkAdapter) {
        self.networkAdapter = networkAdapter
    }

    func loadHomepage(completionHandler: @escaping (InkbunnyHomepageLoadResult) -> Void) {
        let loginURL = URL(string: "https://inkbunny.net/api_login.php")!
        networkAdapter.get(loginURL) { data, _ in
            guard let data = data,
                let json = self.jsonObject(from: data) as? [String : Any],
                  let sid = json["sid"] as? String else {
                completionHandler(.failure)
                return
            }

            let searchURL = URL(string: "https://inkbunny.net/api_search.php?sid=\(sid)")!
            self.networkAdapter.get(searchURL, completionHandler: { data, _ in
                guard let data = data, let json = self.jsonObject(from: data) as? [String : Any] else {
                    completionHandler(.failure)
                    return
                }

                completionHandler(.success(self.parse(json)))
            })
        }
    }

    private func jsonObject(from data: Data) -> Any? {
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
    }

    private func parse(_ json: [String : Any]) -> [InkbunnyHomepageItem] {
        guard let submissions = json["submissions"] as? [[String : Any]] else { return [] }

        var items = [InkbunnyHomepageItem]()
        for submission in submissions {
            guard let title = submission["title"] as? String else { continue }

            let item = InkbunnyHomepageItem(title: title)
            items.append(item)
        }

        return items
    }

}

class CapturingInkbunnyHomepageHandler {

    private(set) var wasNotifiedFeedDidFailToLoad = false
    private(set) var wasNotifiedFeedLoaded = false
    private(set) var results: [InkbunnyHomepageItem]?
    func verify(_ result: InkbunnyHomepageLoadResult) {
        switch result {
        case .success(let results):
            self.results = results
            wasNotifiedFeedLoaded = true

        case .failure:
            wasNotifiedFeedDidFailToLoad = true
        }
    }

    func result(at index: Int) -> InkbunnyHomepageItem? {
        guard let results = results, index < results.count else { return nil }
        return results[index]
    }

}

class InkbunnyAPITests: XCTestCase {

    func testAttemptingToFetchHomepageWhenNotLoggedInGetsLoginEndpoint() {
        let expectedLoginURL = URL(string: "https://inkbunny.net/api_login.php")!
        let capturingNetworkAdapter = CapturingNetworkAdapter()
        let inkbunnyAPI = InkbunnyAPI(networkAdapter: capturingNetworkAdapter)
        inkbunnyAPI.loadHomepage(completionHandler: { _ in })

        XCTAssertEqual(expectedLoginURL, capturingNetworkAdapter.requestedURL)
    }

    func testAttemptingToFetchHomepageWhereGuestLoginFailsInvokesHandlerWithFailure() {
        let capturingNetworkAdapter = FailingNetworkAdapter()
        let inkbunnyAPI = InkbunnyAPI(networkAdapter: capturingNetworkAdapter)
        let capturingHomepageHandler = CapturingInkbunnyHomepageHandler()
        inkbunnyAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertTrue(capturingHomepageHandler.wasNotifiedFeedDidFailToLoad)
    }

    func testHandlerNotInvokedWhenLoginFailsUntilNetworkResponds() {
        let capturingNetworkAdapter = BlockingNetworkAdapter(adapter: FailingNetworkAdapter())
        let inkbunnyAPI = InkbunnyAPI(networkAdapter: capturingNetworkAdapter)
        let capturingHomepageHandler = CapturingInkbunnyHomepageHandler()
        inkbunnyAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertFalse(capturingHomepageHandler.wasNotifiedFeedDidFailToLoad)
    }

    func testLoginRequestReturnsValidResponseRequestsSearchEndpoint() {
        let expectedSearchEndpoint = URL(string: "https://inkbunny.net/api_search.php")!
        let successfulNetworkAdapter = SuccessfulNetworkAdapter(contentsOfJSONFile: "ValidInkbunnyGuestLoginResponse")
        let journallingNetworkAdapter = JournallingNetworkAdapter(networkAdapter: successfulNetworkAdapter)
        let inkbunnyAPI = InkbunnyAPI(networkAdapter: journallingNetworkAdapter)
        let capturingHomepageHandler = CapturingInkbunnyHomepageHandler()
        inkbunnyAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertTrue(journallingNetworkAdapter.lastGetURLContains(expectedSearchEndpoint.absoluteString))
    }

    func testLoginRequestReturnsValidResponseDoesNotNotifyHandlerAboutFailure() {
        var controllableNetworkAdapter = ControllableNetworkAdapter()
        controllableNetworkAdapter.stub(url: URL(string: "https://inkbunny.net/api_login.php")!, withContentsOfJSONFile: "ValidInkbunnyGuestLoginResponse")
        let inkbunnyAPI = InkbunnyAPI(networkAdapter: controllableNetworkAdapter)
        let capturingHomepageHandler = CapturingInkbunnyHomepageHandler()
        inkbunnyAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertFalse(capturingHomepageHandler.wasNotifiedFeedDidFailToLoad)
    }

    func testLoginReturnsInvalidResponseDoesNotAttemptToFetchFromSearchEndpoint() {
        let capturingNetworkAdapter = FailingNetworkAdapter()
        let journallingNetworkAdapter = JournallingNetworkAdapter(networkAdapter: capturingNetworkAdapter)
        let inkbunnyAPI = InkbunnyAPI(networkAdapter: journallingNetworkAdapter)
        let capturingHomepageHandler = CapturingInkbunnyHomepageHandler()
        inkbunnyAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertFalse(journallingNetworkAdapter.lastGetURLContains("api_search.php"))
    }

    func testLoginReturnsInvalidJSONDataNotifiesHandlerOfFailure() {
        let invalidJSONData = "{what!".data(using: .utf8)
        let invalidJSONNetworkAdapter = SuccessfulNetworkAdapter(data: invalidJSONData)
        let inkbunnyAPI = InkbunnyAPI(networkAdapter: invalidJSONNetworkAdapter)
        let capturingHomepageHandler = CapturingInkbunnyHomepageHandler()
        inkbunnyAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertTrue(capturingHomepageHandler.wasNotifiedFeedDidFailToLoad)
    }

    func testLoginReturnsValidJSONWithoutSidFieldNotifiesHandlerOfFailure() {
        let missingSidJSON = "{\"notsid\": \"value\"}".data(using: .utf8)
        let missingSidNetworkAdapter = SuccessfulNetworkAdapter(data: missingSidJSON)
        let inkbunnyAPI = InkbunnyAPI(networkAdapter: missingSidNetworkAdapter)
        let capturingHomepageHandler = CapturingInkbunnyHomepageHandler()
        inkbunnyAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertTrue(capturingHomepageHandler.wasNotifiedFeedDidFailToLoad)
    }

    func testLoginReturnsValidJSONWithSidFieldUsesSidFieldForSearchRequest() {
        let sidFromJSON = "This_Is_A_Test_Token"
        let successfulLoginNetworkAdapter = SuccessfulNetworkAdapter(contentsOfJSONFile: "ValidInkbunnyGuestLoginResponse")
        let journallingNetworkAdapter = JournallingNetworkAdapter(networkAdapter: successfulLoginNetworkAdapter)
        let inkbunnyAPI = InkbunnyAPI(networkAdapter: journallingNetworkAdapter)
        let capturingHomepageHandler = CapturingInkbunnyHomepageHandler()
        inkbunnyAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

         XCTAssertTrue(journallingNetworkAdapter.lastGetURLContains("api_search.php?sid=\(sidFromJSON)"))
    }

    func testSearchFailsAfterLoginSucceedsNotifiesHandlerOfFailure() {
        var controllableNetworkAdapter = ControllableNetworkAdapter()
        controllableNetworkAdapter.stub(url: URL(string: "https://inkbunny.net/api_login.php")!, withContentsOfJSONFile: "ValidInkbunnyGuestLoginResponse")
        controllableNetworkAdapter.stubFailure(url: URL(string: "https://inkbunny.net/api_search.php?sid=This_Is_A_Test_Token")!)

        let inkbunnyAPI = InkbunnyAPI(networkAdapter: controllableNetworkAdapter)
        let capturingHomepageHandler = CapturingInkbunnyHomepageHandler()
        inkbunnyAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertTrue(capturingHomepageHandler.wasNotifiedFeedDidFailToLoad)
    }

    func testSearchSucceedsWithInvalidJSONAfterGuestLoginSucceedsNotifiesHandlerOfFailure() {
        var controllableNetworkAdapter = ControllableNetworkAdapter()
        controllableNetworkAdapter.stub(url: URL(string: "https://inkbunny.net/api_login.php")!, withContentsOfJSONFile: "ValidInkbunnyGuestLoginResponse")
        let invalidJSON = "{what!".data(using: .utf8)!
        controllableNetworkAdapter.stub(url: URL(string: "https://inkbunny.net/api_search.php?sid=This_Is_A_Test_Token")!, with: invalidJSON)
        let inkbunnyAPI = InkbunnyAPI(networkAdapter: controllableNetworkAdapter)
        let capturingHomepageHandler = CapturingInkbunnyHomepageHandler()
        inkbunnyAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertTrue(capturingHomepageHandler.wasNotifiedFeedDidFailToLoad)
    }

    func testSearchSucceedsWithValidJSONNotifiesHandlerOfSuccess() {
        var controllableNetworkAdapter = ControllableNetworkAdapter()
        controllableNetworkAdapter.stub(url: URL(string: "https://inkbunny.net/api_login.php")!, withContentsOfJSONFile: "ValidInkbunnyGuestLoginResponse")
        controllableNetworkAdapter.stub(url: URL(string: "https://inkbunny.net/api_search.php?sid=This_Is_A_Test_Token")!, withContentsOfJSONFile: "ValidInkbunnySearchResponse")

        let inkbunnyAPI = InkbunnyAPI(networkAdapter: controllableNetworkAdapter)
        let capturingHomepageHandler = CapturingInkbunnyHomepageHandler()
        inkbunnyAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertTrue(capturingHomepageHandler.wasNotifiedFeedLoaded)
    }

    func testLoginFailsDoesNotNotifyHandlerOfSuccess() {
        let capturingNetworkAdapter = FailingNetworkAdapter()
        let inkbunnyAPI = InkbunnyAPI(networkAdapter: capturingNetworkAdapter)
        let capturingHomepageHandler = CapturingInkbunnyHomepageHandler()
        inkbunnyAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertFalse(capturingHomepageHandler.wasNotifiedFeedLoaded)
    }

    func testLoginSucceedsThenSearchFailsDoesNotNotifyHandlerOfSuccess() {
        var controllableNetworkAdapter = ControllableNetworkAdapter()
        controllableNetworkAdapter.stub(url: URL(string: "https://inkbunny.net/api_login.php")!, withContentsOfJSONFile: "ValidInkbunnyGuestLoginResponse")
        controllableNetworkAdapter.stubFailure(url: URL(string: "https://inkbunny.net/api_search.php?sid=This_Is_A_Test_Token")!)
        let inkbunnyAPI = InkbunnyAPI(networkAdapter: controllableNetworkAdapter)
        let capturingHomepageHandler = CapturingInkbunnyHomepageHandler()
        inkbunnyAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertFalse(capturingHomepageHandler.wasNotifiedFeedLoaded)
    }

    func testSearchSucceedsWithValidJSONDoesNotNotifyHandlerOfFailure() {
        var controllableNetworkAdapter = ControllableNetworkAdapter()
        controllableNetworkAdapter.stub(url: URL(string: "https://inkbunny.net/api_login.php")!, withContentsOfJSONFile: "ValidInkbunnyGuestLoginResponse")
        controllableNetworkAdapter.stub(url: URL(string: "https://inkbunny.net/api_search.php?sid=This_Is_A_Test_Token")!, withContentsOfJSONFile: "ValidInkbunnySearchResponse")

        let inkbunnyAPI = InkbunnyAPI(networkAdapter: controllableNetworkAdapter)
        let capturingHomepageHandler = CapturingInkbunnyHomepageHandler()
        inkbunnyAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertFalse(capturingHomepageHandler.wasNotifiedFeedDidFailToLoad)
    }

    func testSearchSucceedsProvidesHandlerWithItemConfiguredWithTitle() {
        let firstTitleInSearchJSON = "Green Batsu OTA (OPEN"
        var controllableNetworkAdapter = ControllableNetworkAdapter()
        controllableNetworkAdapter.stub(url: URL(string: "https://inkbunny.net/api_login.php")!, withContentsOfJSONFile: "ValidInkbunnyGuestLoginResponse")
        controllableNetworkAdapter.stub(url: URL(string: "https://inkbunny.net/api_search.php?sid=This_Is_A_Test_Token")!, withContentsOfJSONFile: "ValidInkbunnySearchResponse")

        let inkbunnyAPI = InkbunnyAPI(networkAdapter: controllableNetworkAdapter)
        let capturingHomepageHandler = CapturingInkbunnyHomepageHandler()
        inkbunnyAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertEqual(firstTitleInSearchJSON, capturingHomepageHandler.results?.first?.title)
    }

    func testSearchSucceedsProvidesHandlerWithSecondItemConfiguredWithTitle() {
        let secondTitleInSearchJSON = "Groot's Undies"
        var controllableNetworkAdapter = ControllableNetworkAdapter()
        controllableNetworkAdapter.stub(url: URL(string: "https://inkbunny.net/api_login.php")!, withContentsOfJSONFile: "ValidInkbunnyGuestLoginResponse")
        controllableNetworkAdapter.stub(url: URL(string: "https://inkbunny.net/api_search.php?sid=This_Is_A_Test_Token")!, withContentsOfJSONFile: "ValidInkbunnySearchResponse")

        let inkbunnyAPI = InkbunnyAPI(networkAdapter: controllableNetworkAdapter)
        let capturingHomepageHandler = CapturingInkbunnyHomepageHandler()
        inkbunnyAPI.loadHomepage(completionHandler: capturingHomepageHandler.verify)

        XCTAssertEqual(secondTitleInSearchJSON, capturingHomepageHandler.result(at: 1)?.title)
    }

}
