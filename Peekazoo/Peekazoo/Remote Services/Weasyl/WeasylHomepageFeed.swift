//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

struct WeasylHomepageFeed {

    var networkAdapter: NetworkAdapter
    private let homepageURL = URL(string: "https://www.weasyl.com/api/submissions/frontpage")!

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

    private func parse(_ jsonObject: [[String : Any]]) -> [WeasylHomepageItem] {
        return jsonObject.flatMap(WeasylHomepageItem.init)
    }

}
