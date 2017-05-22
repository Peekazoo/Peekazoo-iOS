//
//  InkbunnySubmission.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 20/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

fileprivate func makeParsingDateFormatter() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSZZZZ"

    return dateFormatter
}

public struct InkbunnySubmission {

    public var submissionID: String
    public var title: String
    public var postedDate = Date()

    public init(submissionID: String, title: String) {
        self.submissionID = submissionID
        self.title = title
    }

    init?(jsonObject: [String : Any]) {
        guard let title = jsonObject["title"] as? String,
              let submissionID = jsonObject["submission_id"] as? String,
              let dateString = jsonObject["create_datetime"] as? String else { return nil }

        self.title = title
        self.submissionID = submissionID
        self.postedDate = makeParsingDateFormatter().date(from: dateString)!
    }

}
