//
//  InkbunnySubmission.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 20/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

public struct InkbunnySubmission {

    public var submissionID: String
    public var title: String
    public var postedDate: Date

    public init(submissionID: String, title: String, postedDate: Date) {
        self.submissionID = submissionID
        self.title = title
        self.postedDate = postedDate
    }

}
