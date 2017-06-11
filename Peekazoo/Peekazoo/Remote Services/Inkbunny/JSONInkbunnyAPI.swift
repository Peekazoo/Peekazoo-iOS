//
//  JSONInkbunnyAPI.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 20/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

public struct JSONInkbunnyAPI: InkbunnyAPI {

    private var networkAdapter: NetworkAdapter

    public init(networkAdapter: NetworkAdapter) {
        self.networkAdapter = networkAdapter
    }

    public func loadHomepage(completionHandler: @escaping (InkbunnyHomepageLoadResult) -> Void) {
        networkAdapter.get(makeGuestLoginURL()) { data, _ in
            guard let data = data,
                  let response = try? JSONDecoder().decode(JSONInkbunnyLoginResponse.self, from: data) else {
                    completionHandler(.failure)
                    return
            }

            self.networkAdapter.get(self.makeSearchURL(sid: response.sessionIdentifier)) { data, _ in
                guard let data = data,
                    let response = try? JSONDecoder().decode(JSONInkbunnySearchResponse.self, from: data) else {
                    completionHandler(.failure)
                    return
                }

                completionHandler(.success(response.submissions))
            }
        }
    }

    private func makeGuestLoginURL() -> URL {
        return URL(string: "https://inkbunny.net/api_login.php?username=guest&password=")!
    }

    private func makeSearchURL(sid: String) -> URL {
        return URL(string: "https://inkbunny.net/api_search.php?sid=\(sid)")!
    }

}
