//
//  JSONWeasylSubmission.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 18/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

struct JSONWeasylSubmission: WeasylSubmission, Decodable {

    public var title: String
    public var submitID: Int
    public var postedAt: Date

    private enum CodingKeys: String, CodingKey {
        case title
        case submitID = "submitid"
        case postedAt = "posted_at"
    }

}
