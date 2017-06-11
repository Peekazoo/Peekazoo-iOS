//
//  JSONInkbunnyAPI.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 20/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

public struct JSONInkbunnyAPI: InkbunnyAPI {

    private let jsonFetcher: JSONFetcher

    public init(networkAdapter: NetworkAdapter) {
        jsonFetcher = JSONFetcher(networkAdapter: networkAdapter)
    }

    public func loadHomepage(completionHandler: @escaping (InkbunnyHomepageLoadResult) -> Void) {
        performGuestLogin { (result) in
            switch result {
            case .failure:
                completionHandler(.failure)

            case .success(let response):
                self.performSearch(sid: response.sessionIdentifier) { (searchResult) in
                    switch searchResult {
                    case .failure:
                        completionHandler(.failure)

                    case .success(let searchResponse):
                        completionHandler(.success(searchResponse.submissions))
                    }
                }
            }
        }
    }

    private func performGuestLogin(completionHandler: @escaping (JSONFetcher.Result<JSONInkbunnyLoginResponse>) -> Void) {
        jsonFetcher.fetchJSON(from: makeGuestLoginURL(),
                              representing: JSONInkbunnyLoginResponse.self,
                              completionHandler: completionHandler)
    }

    private func performSearch(sid: String, completionHandler: @escaping (JSONFetcher.Result<JSONInkbunnySearchResponse>) -> Void) {
        jsonFetcher.fetchJSON(from: makeSearchURL(sid: sid),
                              representing: JSONInkbunnySearchResponse.self,
                              completionHandler: completionHandler)
    }

    private func makeGuestLoginURL() -> URL {
        return URL(string: "https://inkbunny.net/api_login.php?username=guest&password=")!
    }

    private func makeSearchURL(sid: String) -> URL {
        return URL(string: "https://inkbunny.net/api_search.php?sid=\(sid)")!
    }

}
