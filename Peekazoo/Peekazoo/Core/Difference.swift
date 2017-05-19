//
//  Difference.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 19/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

enum Difference {

    case insertion(index: Int)

    var insertedIndex: Int? {
        if case .insertion(let idx) = self {
            return idx
        } else {
            return nil
        }
    }
    
}
