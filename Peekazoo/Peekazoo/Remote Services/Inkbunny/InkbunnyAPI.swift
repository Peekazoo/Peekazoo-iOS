//
//  InkbunnyAPI.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 20/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

enum InkbunnyHomepageLoadResult {
    case success([InkbunnySubmission])
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

    private func parse(_ json: [String : Any]) -> [InkbunnySubmission] {
        guard let submissions = json["submissions"] as? [[String : Any]] else { return [] }

        var items = [InkbunnySubmission]()
        for submission in submissions {
            guard let title = submission["title"] as? String,
                let submissionID = submission["submission_id"] as? String else { continue }

            let item = InkbunnySubmission(submissionID: submissionID, title: title)
            items.append(item)
        }

        return items
    }

}
