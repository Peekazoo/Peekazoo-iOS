//
//  TemporalDistanceMeasurerTestDoubles.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 23/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation
import Peekazoo

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
