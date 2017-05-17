//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

struct WeasylHomepageFeed: HomepageFeed {

    struct WeasylHomepageItem: HomepageItem {

        var contentIdentifier: String
        var title: String

    }

    let homepageURL = URL(string: "https://www.weasyl.com/api/submissions/frontpage")!

    func loadFeed(networkAdapter: NetworkAdapter, delegate: HomepageFeedDelegate) {
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
        var homepageItems = [HomepageItem]()
        for object in jsonObject {
            guard let title = object["title"] as? String,
                  let contentIdentifier = object["submitid"] as? Int else { continue }

            let item = WeasylHomepageItem(contentIdentifier: String(contentIdentifier), title: title)
            homepageItems.append(item)
        }

        return homepageItems
    }

}
