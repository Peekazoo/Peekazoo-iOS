//
//  WeasylSubmission.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 18/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

public struct WeasylSubmission {

    public var title: String
    public var submitID: String
    public var postedAt: Date = Date()

    public init(submitID: String, title: String) {
        self.submitID = submitID
        self.title = title
    }

    init?(jsonObject: [String : Any]) {
        guard let title = jsonObject["title"] as? String,
              let submitID = jsonObject["submitid"] as? Int,
              let postedAtString = jsonObject["posted_at"] as? String else { return nil }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" //2017-05-08T19:12:45Z

        self.title = title
        self.submitID = String(submitID)
        self.postedAt = dateFormatter.date(from: postedAtString) ?? Date()
    }

}
