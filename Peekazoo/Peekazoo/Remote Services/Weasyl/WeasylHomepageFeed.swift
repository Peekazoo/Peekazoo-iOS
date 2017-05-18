//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

struct WeasylHomepageFeed: HomepageFeed {

    struct WeasylHomepageItem: HomepageItem {

        var contentIdentifier: String
        var title: String

        fileprivate init?(jsonObject: [String : Any]) {
            guard let title = jsonObject["title"] as? String,
                  let contentIdentifier = jsonObject["submitid"] as? Int else { return nil }

            self.title = title
            self.contentIdentifier = String(contentIdentifier)
        }

    }

    var networkAdapter: NetworkAdapter
    private let homepageURL = URL(string: "https://www.weasyl.com/api/submissions/frontpage")!

    func loadFeed(delegate: HomepageFeedDelegate) {
        networkAdapter.get(homepageURL) { data, _ in
            if let data = data {
                self.parseHomepageItems(from: data, delegate: delegate)
            } else {
                delegate.feedDidFailToLoad()
            }
        }
    }

    private func parseHomepageItems(from data: Data, delegate: HomepageFeedDelegate) {
        if let jsonObject = self.jsonObject(from: data) {
            delegate.feedDidFinishLoading(items: parse(jsonObject))
        } else {
            delegate.feedDidFailToLoad()
        }
    }

    private func jsonObject(from data: Data) -> [[String : Any]]? {
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [[String : Any]]
    }

    private func parse(_ jsonObject: [[String : Any]]) -> [HomepageItem] {
        return jsonObject.flatMap(WeasylHomepageItem.init)
    }

}
