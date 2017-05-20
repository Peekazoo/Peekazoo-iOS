//
//  InkbunnySubmission.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 20/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

struct InkbunnySubmission {

    var submissionID: String
    var title: String

    init?(jsonObject: [String : Any]) {
        guard let title = jsonObject["title"] as? String,
              let submissionID = jsonObject["submission_id"] as? String else { return nil }

        self.title = title
        self.submissionID = submissionID
    }

}
