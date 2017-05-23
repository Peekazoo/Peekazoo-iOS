//
//  TimeFormatterTestDoubles.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 23/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation
import Peekazoo

struct DummyTimeFormatter: TimeFormatter {

    func string(from date: Date) { }

}

class CapturingTimeFormatter: TimeFormatter {

    private(set) var capturedDateToFormat: Date?
    func string(from date: Date) {
        capturedDateToFormat = date
    }

}
