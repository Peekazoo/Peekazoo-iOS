//
//  JSONWeasylHomepageAPI.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 18/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

struct JSONWeasylHomepageAPI {

    private var networkAdapter: NetworkAdapter
    private var dateFormatter: DateFormatter
    private let homepageURL = URL(string: "https://www.weasyl.com/api/submissions/frontpage")!

    init(networkAdapter: NetworkAdapter) {
        self.networkAdapter = networkAdapter

        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    }

    func loadFeed(completionHandler: @escaping (WeasylHomepageLoadResult) -> Void) {
        networkAdapter.get(homepageURL) { data, _ in
            if let data = data {
                self.parseHomepageItems(from: data, completionHandler: completionHandler)
            } else {
                completionHandler(.failure)
            }
        }
    }

    private func parseHomepageItems(from data: Data, completionHandler: (WeasylHomepageLoadResult) -> Void) {
        if let jsonObject = self.jsonObject(from: data) {
            completionHandler(.success(parse(jsonObject)))
        } else {
            completionHandler(.failure)
        }
    }

    private func jsonObject(from data: Data) -> [[String : Any]]? {
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [[String : Any]]
    }

    private func parse(_ jsonObject: [[String : Any]]) -> [JSONWeasylSubmission] {
        return jsonObject.flatMap(parseSubmission)
    }

    private func parseSubmission(_ jsonObject: [String : Any]) -> JSONWeasylSubmission? {
        guard let submitID = jsonObject["submitid"] as? Int,
              let title = jsonObject["title"] as? String,
              let postedAtString = jsonObject["posted_at"] as? String,
              let postedAt = dateFormatter.date(from: postedAtString) else { return nil }

        return JSONWeasylSubmission(submitID: String(submitID), title: title, postedAt: postedAt)
    }

}
