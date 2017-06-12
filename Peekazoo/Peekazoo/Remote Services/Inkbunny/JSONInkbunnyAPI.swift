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
        let decoder = JSONDecoder()
        let inkbunnyDateFormatter = DateFormatter()
        inkbunnyDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSZZZZ"
        decoder.dateDecodingStrategy = .formatted(inkbunnyDateFormatter)

        jsonFetcher = JSONFetcher(decoder: decoder, networkAdapter: networkAdapter)
    }

    public func loadHomepage(completionHandler: @escaping (InkbunnyHomepageLoadResult) -> Void) {
        performGuestLogin { (result) in
            switch result {
            case .failure:
                completionHandler(.failure)

            case .success(let response):
                self.performSearch(sid: response.sessionIdentifier, completionHandler: completionHandler)
            }
        }
    }

    private func performGuestLogin(completionHandler: @escaping (JSONFetcher.Result<JSONInkbunnyLoginResponse>) -> Void) {
        let guestLoginURL = URL(string: "https://inkbunny.net/api_login.php?username=guest&password=")!
        jsonFetcher.fetchJSON(from: guestLoginURL,
                              representing: JSONInkbunnyLoginResponse.self,
                              completionHandler: completionHandler)
    }

    private func performSearch(sid: String, completionHandler: @escaping (InkbunnyHomepageLoadResult) -> Void) {
        let searchURL = URL(string: "https://inkbunny.net/api_search.php?sid=\(sid)")!
        jsonFetcher.fetchJSON(from: searchURL, representing: JSONInkbunnySearchResponse.self) { (response) in
            switch response {
            case .success(let searchResponse):
                completionHandler(.success(searchResponse.submissions))

            case .failure:
                completionHandler(.failure)
            }
        }
    }

}
