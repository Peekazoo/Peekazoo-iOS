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

struct InkbunnyAPI: InkbunnyAPIProtocol {

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
                guard let data = data,
                      let json = self.jsonObject(from: data) as? [String : Any],
                      let submissions = json["submissions"] as? [[String : Any]] else {
                    completionHandler(.failure)
                    return
                }

                completionHandler(.success(submissions.flatMap(InkbunnySubmission.init)))
            })
        }
    }

    private func jsonObject(from data: Data) -> Any? {
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
    }

}
