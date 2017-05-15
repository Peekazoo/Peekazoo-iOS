//
//  StubHomepageItem.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 15/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo

struct StubHomepageItem: HomepageItem {

    var title: String

    init(title: String = "") {
        self.title = title
    }

}
