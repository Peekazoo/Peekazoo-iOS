//
//  WeasylHomepageItem.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 18/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

struct WeasylHomepageItem {

    var title: String
    var submitID: String

    init(submitID: String, title: String) {
        self.submitID = submitID
        self.title = title
    }

    init?(jsonObject: [String : Any]) {
        guard let title = jsonObject["title"] as? String,
              let submitID = jsonObject["submitid"] as? Int else { return nil }

        self.title = title
        self.submitID = String(submitID)
    }

}
