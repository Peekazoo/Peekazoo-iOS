//
//  RelativeTimeFormatterTests.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 23/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Peekazoo
import XCTest

struct RelativeTimeFormatter: TimeFormatter {

    func string(from date: Date) -> String {
        return "Just now"
    }

}

class RelativeTimeFormatterTests: XCTestCase {

    func testRequestingTimeWithinOneMinuteReturnsJustNow() {
        let formatter = RelativeTimeFormatter()
        let withinOneMinute = Date(timeIntervalSinceNow: -59)
        let formattedString = formatter.string(from: withinOneMinute)

        XCTAssertEqual("Just now", formattedString)
    }

}
