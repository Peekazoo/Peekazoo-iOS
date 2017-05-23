//
//  RelativeTimeFormatterTests.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 23/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Peekazoo
import XCTest

protocol TemporalDistanceMeasurer {

    func measureDistance(from date: Date) -> TimeInterval

}

struct DateTemporalDistanceMeasurer: TemporalDistanceMeasurer {

    func measureDistance(from date: Date) -> TimeInterval {
        return Date().timeIntervalSince(date)
    }

}

class StubTemporalDistanceMeasurer: TemporalDistanceMeasurer {

    private var temporalDistance: TimeInterval

    init(temporalDistance: TimeInterval = 0) {
        self.temporalDistance = temporalDistance
    }

    func measureDistance(from date: Date) -> TimeInterval {
        return temporalDistance
    }

}

class CapturingTemporalDistanceMeasurer: StubTemporalDistanceMeasurer {

    private(set) var capturedDate: Date?
    override func measureDistance(from date: Date) -> TimeInterval {
        capturedDate = date
        return super.measureDistance(from: date)
    }

}

struct RelativeTimeFormatter: TimeFormatter {

    var temporalDistanceMeasurer: TemporalDistanceMeasurer

    init(temporalDistanceMeasurer: TemporalDistanceMeasurer = DateTemporalDistanceMeasurer()) {
        self.temporalDistanceMeasurer = temporalDistanceMeasurer
    }

    func string(from date: Date) -> String {
        let distance = temporalDistanceMeasurer.measureDistance(from: date)
        switch distance {
        case _ where distance > 7199:
            return "2 hours ago"

        case _ where distance > 3599:
            return "1 hour ago"

        case _ where distance >= 120:
            return "\(Int(distance) / 60) minutes ago"

        case _ where distance > 60:
            return "1 minute ago"

        default:
            return "Just now"
        }
    }

}

class RelativeTimeFormatterTests: XCTestCase {

    func testRequestingTimeMeasuresDistanceFromProvidedDate() {
        let temporalMeasurer = CapturingTemporalDistanceMeasurer()
        let formatter = RelativeTimeFormatter(temporalDistanceMeasurer: temporalMeasurer)
        let date = Date(timeIntervalSinceNow: 42)
        _ = formatter.string(from: date)

        XCTAssertEqual(date, temporalMeasurer.capturedDate)
    }

    func testRequestingTimeWithinOneMinuteReturnsJustNow() {
        let temporalMeasurer = StubTemporalDistanceMeasurer(temporalDistance: 59)
        let formatter = RelativeTimeFormatter(temporalDistanceMeasurer: temporalMeasurer)
        let formattedString = formatter.string(from: Date())

        XCTAssertEqual("Just now", formattedString)
    }

    func testRequestingTimeWithinTwoMinutesReturnOneMinuteAgo() {
        let temporalMeasurer = StubTemporalDistanceMeasurer(temporalDistance: 119)
        let formatter = RelativeTimeFormatter(temporalDistanceMeasurer: temporalMeasurer)
        let formattedString = formatter.string(from: Date())

        XCTAssertEqual("1 minute ago", formattedString)
    }

    func testRequestingTimeTwoMinutesAgoReturnsTwoMinutes() {
        let temporalMeasurer = StubTemporalDistanceMeasurer(temporalDistance: 120)
        let formatter = RelativeTimeFormatter(temporalDistanceMeasurer: temporalMeasurer)
        let formattedString = formatter.string(from: Date())

        XCTAssertEqual("2 minutes ago", formattedString)
    }

    func testRequestingTimeWithinAnHourReturnsNumberOfMinutes() {
        let temporalMeasurer = StubTemporalDistanceMeasurer(temporalDistance: 3599)
        let formatter = RelativeTimeFormatter(temporalDistanceMeasurer: temporalMeasurer)
        let formattedString = formatter.string(from: Date())

        XCTAssertEqual("59 minutes ago", formattedString)
    }

    func testRequestingTimeForOneHourReturnsOneHourAgo() {
        let temporalMeasurer = StubTemporalDistanceMeasurer(temporalDistance: 3600)
        let formatter = RelativeTimeFormatter(temporalDistanceMeasurer: temporalMeasurer)
        let formattedString = formatter.string(from: Date())

        XCTAssertEqual("1 hour ago", formattedString)
    }

    func testRequestingTimeForTwoHoursReturnsTwoHoursAgo() {
        let temporalMeasurer = StubTemporalDistanceMeasurer(temporalDistance: 7200)
        let formatter = RelativeTimeFormatter(temporalDistanceMeasurer: temporalMeasurer)
        let formattedString = formatter.string(from: Date())

        XCTAssertEqual("2 hours ago", formattedString)
    }

}
