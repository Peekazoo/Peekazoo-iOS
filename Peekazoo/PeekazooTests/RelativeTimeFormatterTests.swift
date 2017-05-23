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
        let now = Date()
        let distance = now.timeIntervalSince(date)
        if distance > 60 {
            if distance > 120 {
                return "2 minutes ago"
            } else {
                return "1 minute ago"
            }
        } else {
            return "Just now"
        }
    }

}

class RelativeTimeFormatterTests: XCTestCase {

    func testRequestingTimeWithinOneMinuteReturnsJustNow() {
        let formatter = RelativeTimeFormatter()
        let withinOneMinute = Date(timeIntervalSinceNow: -59)
        let formattedString = formatter.string(from: withinOneMinute)

        XCTAssertEqual("Just now", formattedString)
    }

    func testRequestingTimeWithinTwoMinutesReturnOneMinuteAgo() {
        let formatter = RelativeTimeFormatter()
        let withinTwoMinutes = Date(timeIntervalSinceNow: -119)
        let formattedString = formatter.string(from: withinTwoMinutes)

        XCTAssertEqual("1 minute ago", formattedString)
    }

    func testRequestingTimeTwoMinutesAgoReturnsTwoMinutes() {
        let formatter = RelativeTimeFormatter()
        let twoMinutesAgo = Date(timeIntervalSinceNow: -120)
        let formattedString = formatter.string(from: twoMinutesAgo)

        XCTAssertEqual("2 minutes ago", formattedString)
    }

}
