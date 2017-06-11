//
//  InkbunnySubmission.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 10/06/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

public protocol InkbunnySubmission {

    var submissionID: String { get }
    var title: String { get }
    var postedDate: Date { get }

}
