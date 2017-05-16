//
//  Randomness.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 15/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

extension Int {

    static func random(upperLimit: UInt32, lowerLimit: Int = 0) -> Int {
        return Swift.max(Int(arc4random_uniform(upperLimit)), lowerLimit)
    }

}
