//
//  RelativeTimeFormatter.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 23/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

public struct RelativeTimeFormatter: TimeFormatter {

    var temporalDistanceMeasurer: TemporalDistanceMeasurer
    let dateFormatter: DateFormatter

    public init(temporalDistanceMeasurer: TemporalDistanceMeasurer = DateTemporalDistanceMeasurer()) {
        self.temporalDistanceMeasurer = temporalDistanceMeasurer

        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
    }

    public func string(from date: Date) -> String {
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

    private struct DateTemporalDistanceMeasurer: TemporalDistanceMeasurer {

        func measureDistance(from date: Date) -> TimeInterval {
            return Date().timeIntervalSince(date)
        }

    }

}
