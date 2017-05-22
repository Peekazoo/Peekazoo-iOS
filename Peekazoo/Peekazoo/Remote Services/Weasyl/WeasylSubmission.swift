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
    public var postedAt: Date

    public init(submitID: String, title: String, postedAt: Date) {
        self.submitID = submitID
        self.title = title
        self.postedAt = postedAt
    }

}
