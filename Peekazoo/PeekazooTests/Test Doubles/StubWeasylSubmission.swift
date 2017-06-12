//
//  StubWeasylSubmission.swift
//  PeekazooTests
//
//  Created by Thomas Sherwood on 10/06/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation
import Peekazoo

struct StubWeasylSubmission: WeasylSubmission {

    var title: String
    var submitID: Int
    var postedAt: Date

    init(title: String = "", submitID: Int = 0, postedAt: Date = Date()) {
        self.title = title
        self.submitID = submitID
        self.postedAt = postedAt
    }

}
