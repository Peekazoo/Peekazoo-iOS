//
//  StubInkbunnySubmission.swift
//  PeekazooTests
//
//  Created by Thomas Sherwood on 10/06/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation
import Peekazoo

struct StubInkbunnySubmission: InkbunnySubmission {

    var postedDate: Date
    var submissionID: String
    var title: String

    init(postedDate: Date = Date(), submissionID: String = "", title: String = "") {
        self.postedDate = postedDate
        self.submissionID = submissionID
        self.title = title
    }

}
