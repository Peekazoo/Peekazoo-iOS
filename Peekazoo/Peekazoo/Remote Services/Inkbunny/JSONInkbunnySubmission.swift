//
//  InkbunnySubmissionImpl.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 20/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

struct JSONInkbunnySubmission: InkbunnySubmission, Decodable {

    enum CodingKeys: String, CodingKey {
        case submissionID = "submission_id"
        case title
        case createdDateTime = "create_datetime"
    }

    static var dateFormatter: DateFormatter = {
        let submissionDateTimeFormatter = DateFormatter()
        submissionDateTimeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSZZZZ"
        return submissionDateTimeFormatter
    }()

    var submissionID: String
    var title: String
    var postedDate: Date

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        submissionID = try container.decode(String.self, forKey: CodingKeys.submissionID)
        title = try container.decode(String.self, forKey: CodingKeys.title)

        let stringFormedCreatedDate = try container.decode(String.self, forKey: CodingKeys.createdDateTime)
        guard let date = JSONInkbunnySubmission.dateFormatter.date(from: stringFormedCreatedDate) else {
            throw NSError(domain: "", code: 0, userInfo: nil)
        }

        postedDate = date
    }

}
