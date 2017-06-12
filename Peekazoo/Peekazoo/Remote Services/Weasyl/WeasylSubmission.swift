//
//  WeasylSubmission.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 10/06/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

public protocol WeasylSubmission {

    var title: String { get }
    var submitID: Int { get }
    var postedAt: Date { get }

}
