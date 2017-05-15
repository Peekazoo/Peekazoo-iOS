//
//  Randomness.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 15/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

extension Int {

    static func random(upperLimit: UInt32) -> Int {
        return Int(arc4random_uniform(upperLimit))
    }

}
