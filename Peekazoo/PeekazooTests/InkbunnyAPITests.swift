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
    case failure
}

struct InkbunnyAPI {

    var networkAdapter: NetworkAdapter

    init(networkAdapter: NetworkAdapter) {
        self.networkAdapter = networkAdapter
    }

    func loadHomepage(completionHandler: @escaping (InkbunnyHomepageLoadResult) -> Void) {
        let loginURL = URL(string: "https://inkbunny.net/api_login.php")!
        networkAdapter.get(loginURL) { data, _ in
            if data == nil {
                completionHandler(.failure)
            } else {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String : Any]
                    if json?["sid"] == nil {
                        completionHandler(.failure)
                        return
                    }
                } catch {
                    completionHandler(.failure)
                }

                let searchURL = URL(string: "https://inkbunny.net/api_search.php")!
                self.networkAdapter.get(searchURL, completionHandler: { _, _ in })
            }
        }
    }

}

class CapturingInkbunnyHomepageHandler {

    private(set) var wasNotifiedFeedDidFailToLoad = false
    func verify(_ result: InkbunnyHomepageLoadResult) {
        switch result {
        case .failure:
            wasNotifiedFeedDidFailToLoad = true
        }
    }

}

class JournallingNetworkAdapter: NetworkAdapter {

    var networkAdapter: NetworkAdapter

    init(networkAdapter: NetworkAdapter) {
        self.networkAdapter = networkAdapter
    }

    private(set) var getURLs = [URL]()
    func get(_ url: URL, completionHandler: @escaping (Data?, Error?) -> Void) {
        getURLs.append(url)
        networkAdapter.get(url, completionHandler: completionHandler)
    }

    func lastGetURLSatisfies(_ predicate: (URL) -> Bool) -> Bool {
        guard let url = getURLs.last else { return false }
        return predicate(url)
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

        XCTAssertTrue(journallingNetworkAdapter.lastGetURLSatisfies({ $0.absoluteString.contains(expectedSearchEndpoint.absoluteString) }))
    }

    func testLoginRequestReturnsValidResponseDoesNotNotifyHandlerAboutFailure() {
        let successfulNetworkAdapter = SuccessfulNetworkAdapter(contentsOfJSONFile: "ValidInkbunnyGuestLoginResponse")
        let inkbunnyAPI = InkbunnyAPI(networkAdapter: successfulNetworkAdapter)
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

        XCTAssertFalse(journallingNetworkAdapter.lastGetURLSatisfies({ $0.absoluteString.contains("api_search.php") }))
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

}