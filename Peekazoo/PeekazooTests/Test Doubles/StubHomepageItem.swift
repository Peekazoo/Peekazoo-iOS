//
//  StubHomepageItem.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 15/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo
import Foundation

struct StubHomepageItem: HomepageItem {

    var title: String
    var contentIdentifier: String

    init(title: String = "", contentIdentifier: String = UUID().uuidString) {
        self.title = title
        self.contentIdentifier = contentIdentifier
    }

}
