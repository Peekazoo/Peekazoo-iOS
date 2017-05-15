//
//  HomepageViewModel.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 15/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

struct HomepageViewModel: HomepageInterfaceViewModel {

    var content: [HomepageItemViewModel]
    var isEmpty: Bool { return content.isEmpty }

    var numberOfItems: Int {
        return content.count
    }

    init(items: [HomepageItem]) {
        content = items.map(HomepageItemViewModel.init)
    }

    func item(at index: Int) -> HomepageInterfaceItemViewModel {
        return content[index]
    }

}

struct HomepageItemViewModel: HomepageInterfaceItemViewModel {

    var item: HomepageItem

    var title: String {
        return item.title
    }

}
