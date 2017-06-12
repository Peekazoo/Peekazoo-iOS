//
//  JSONWeasylHomepageAPI.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 18/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

struct JSONWeasylHomepageAPI {

    private let jsonFetcher: JSONFetcher
    private let homepageURL = URL(string: "https://www.weasyl.com/api/submissions/frontpage")!

    init(networkAdapter: NetworkAdapter) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        jsonFetcher = JSONFetcher(decoder: decoder, networkAdapter: networkAdapter)
    }

    func loadFeed(completionHandler: @escaping (WeasylHomepageLoadResult) -> Void) {
        jsonFetcher.fetchJSON(from: homepageURL, representing: [JSONWeasylSubmission].self) { (homepageResult) in
            switch homepageResult {
            case .success(let homepage):
                completionHandler(.success(homepage))

            case .failure:
                completionHandler(.failure)
            }
        }
    }

}
