//
//  JSONInkbunnySubmission.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 20/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

struct JSONInkbunnySubmission: InkbunnySubmission, Decodable {

    var submissionID: String
    var title: String
    var postedDate: Date

    private enum CodingKeys: String, CodingKey {
        case submissionID = "submission_id"
        case title
        case postedDate = "create_datetime"
    }

}
