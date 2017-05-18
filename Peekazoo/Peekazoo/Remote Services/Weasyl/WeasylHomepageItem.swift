//
//  WeasylHomepageItem.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 18/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

struct WeasylHomepageItem: HomepageItem {

    var contentIdentifier: String
    var title: String

    init(contentIdentifier: String, title: String) {
        self.contentIdentifier = contentIdentifier
        self.title = title
    }

    init?(jsonObject: [String : Any]) {
        guard let title = jsonObject["title"] as? String,
            let contentIdentifier = jsonObject["submitid"] as? Int else { return nil }

        self.title = title
        self.contentIdentifier = String(contentIdentifier)
    }

}
