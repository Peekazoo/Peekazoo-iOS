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
    let dateFormatter: DateFormatter

    init(temporalDistanceMeasurer: TemporalDistanceMeasurer = DateTemporalDistanceMeasurer()) {
        self.temporalDistanceMeasurer = temporalDistanceMeasurer

        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
    }

    func string(from date: Date) -> String {
        let distance = temporalDistanceMeasurer.measureDistance(from: date)
        switch distance {
        case _ where distance >= 172800:
            return dateFormatter.string(from: date)

        case _ where distance >= 86400:
            return "Yesterday"

        case _ where distance > 7199:
            return "\(Int(distance) / 3600) hours ago"

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

    func testRequestingTimeForWithinOneDayReturnsNumberOfHours() {
        let temporalMeasurer = StubTemporalDistanceMeasurer(temporalDistance: 86340)
        let formatter = RelativeTimeFormatter(temporalDistanceMeasurer: temporalMeasurer)
        let formattedString = formatter.string(from: Date())

        XCTAssertEqual("23 hours ago", formattedString)
    }

    func testRequestingTimeOneDayAgoReturnsYesterday() {
        let temporalMeasurer = StubTemporalDistanceMeasurer(temporalDistance: 86400)
        let formatter = RelativeTimeFormatter(temporalDistanceMeasurer: temporalMeasurer)
        let formattedString = formatter.string(from: Date())

        XCTAssertEqual("Yesterday", formattedString)
    }

    func testRequestingTimeGreaterThanTwoDaysAgoReturnsAbsoluteDate() {
        let temporalMeasurer = StubTemporalDistanceMeasurer(temporalDistance: 172800)
        let formatter = RelativeTimeFormatter(temporalDistanceMeasurer: temporalMeasurer)
        let specificDate = DateComponents(calendar: Calendar.current,
                                          year: 2017,
                                          month: 5,
                                          day: 23,
                                          hour: 21,
                                          minute: 42,
                                          second: 24).date!

        // Using the real formatter gets around locale issues in tests
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let expectedFormatString = dateFormatter.string(from: specificDate)

        let formattedString = formatter.string(from: specificDate)

        XCTAssertEqual(expectedFormatString, formattedString)
    }

}
