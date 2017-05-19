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
            guard let data = data,
                  let json = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String : Any],
                  let sid = json["sid"] as? String else {
                completionHandler(.failure)
                return
            }

            let searchURL = URL(string: "https://inkbunny.net/api_search.php?sid=\(sid)")!
            self.networkAdapter.get(searchURL, completionHandler: { _, error in
                if error != nil {
                    completionHandler(.failure)
                }
            })
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

    func lastGetURLContains(_ component: String) -> Bool {
        guard let url = getURLs.last else { return false }
        return url.absoluteString.contains(component)
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

    struct ControllableNetworkAdapter: NetworkAdapter {

        enum StubResponse {
            case data(Data)
            case error(Error)
        }

        private var responses = [URL: StubResponse]()

        func get(_ url: URL, completionHandler: @escaping (Data?, Error?) -> Void) {
            guard let response = responses[url] else { return }

            switch response {
            case .data(let data):
                completionHandler(data, nil)

            case .error(let error):
                completionHandler(nil, error)
            }
        }

        mutating func stub(url: URL, with data: Data) {
            responses[url] = .data(data)
        }

        mutating func stub(url: URL, withContentsOfJSONFile name: String) {
            let bundle = Bundle(for: SuccessfulNetworkAdapter.self)
            let jsonURL = bundle.url(forResource: name, withExtension: "json")!
            if let data = try? Data(contentsOf: jsonURL) {
                stub(url: url, with: data)
            }
        }

        mutating func stub(url: URL, with error: Error) {
            responses[url] = .error(error)
        }

        mutating func stubFailure(url: URL) {
            let error = NSError(domain: "", code: 0, userInfo: nil)
            stub(url: url, with: error)
        }

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

}
