//
//  TemporalDistanceMeasurer.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 23/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

public protocol TemporalDistanceMeasurer {

    func measureDistance(from date: Date) -> TimeInterval

}
