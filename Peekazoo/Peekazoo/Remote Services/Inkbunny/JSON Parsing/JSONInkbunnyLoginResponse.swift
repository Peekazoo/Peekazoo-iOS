//
//  JSONInkbunnyLoginResponse.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 09/06/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

struct JSONInkbunnyLoginResponse: Decodable {

    var sessionIdentifier: String

    enum CodingKeys: String, CodingKey {
        case sessionIdentifier = "sid"
    }

}
