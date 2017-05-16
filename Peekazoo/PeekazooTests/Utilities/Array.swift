//
//  Array.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 16/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

extension Array {

    func all(_ predicate: (Element) throws -> Bool) rethrows -> Bool {
        for item in self {
            if !(try predicate(item)) {
                return false
            }
        }

        return true
    }

}
