//
//  InkbunnyAPITests.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 19/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo
import XCTest

struct InkbunnyAPI {

    var networkAdapter: NetworkAdapter

    init(networkAdapter: NetworkAdapter) {
        self.networkAdapter = networkAdapter
    }

    func loadHomepage() {
        let loginURL = URL(string: "https://inkbunny.net/api_login.php")!
        networkAdapter.get(loginURL) { _, _ in }
    }

}

class InkbunnyAPITests: XCTestCase {

    func testAttemptingToFetchHomepageWhenNotLoggedInGetsLoginEndpoint() {
        let expectedLoginURL = URL(string: "https://inkbunny.net/api_login.php")!
        let capturingNetworkAdapter = CapturingNetworkAdapter()
        let inkbunnyAPI = InkbunnyAPI(networkAdapter: capturingNetworkAdapter)
        inkbunnyAPI.loadHomepage()

        XCTAssertEqual(expectedLoginURL, capturingNetworkAdapter.requestedURL)
    }

}
