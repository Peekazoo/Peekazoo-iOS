//
//  StubHomepageInterfaceViewModel.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 15/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo

struct StubHomepageInterfaceViewModel: HomepageInterfaceViewModel {

    init(items: [StubHomepageInterfaceItemViewModel]) {
        self.items = items
    }

    var items: [StubHomepageInterfaceItemViewModel]
    var numberOfItems: Int { return items.count }

    func item(at index: Int) -> HomepageInterfaceItemViewModel {
        return items[index]
    }

}

struct StubHomepageInterfaceItemViewModel: HomepageInterfaceItemViewModel {

    var title: String = ""

}
