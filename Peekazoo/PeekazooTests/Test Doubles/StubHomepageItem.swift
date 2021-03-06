//
//  StubHomepageItem.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 15/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Peekazoo
import Foundation

struct StubHomepageItem: HomepageItem, Equatable {

    var title: String
    var contentIdentifier: String
    var creationDate: Date

    init(title: String = "", contentIdentifier: String = UUID().uuidString, creationDate: Date = Date()) {
        self.title = title
        self.contentIdentifier = contentIdentifier
        self.creationDate = creationDate
    }

    static func ==(lhs: StubHomepageItem, rhs: StubHomepageItem) -> Bool {
        return lhs.title == rhs.title &&
               lhs.contentIdentifier == rhs.contentIdentifier &&
               lhs.creationDate == rhs.creationDate
    }

}
