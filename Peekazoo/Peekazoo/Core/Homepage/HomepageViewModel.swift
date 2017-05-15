//
//  HomepageViewModel.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 15/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

struct HomepageViewModel: HomepageInterfaceViewModel {

    var content: [HomepageItemViewModel] = []
    var isEmpty: Bool { return content.isEmpty }

    var numberOfItems: Int {
        return content.count
    }

    mutating func union(items: [HomepageItem]) {
        let existingIdentifiers = content.map({ $0.item.contentIdentifier })
        let newItems = items.filter(isNotRepresentedByExistingIdentifiers(existingIdentifiers))
        content = newItems.map(HomepageItemViewModel.init) + content
    }

    private func isNotRepresentedByExistingIdentifiers(_ identifiers: [String]) -> (HomepageItem) -> Bool {
        return { !identifiers.contains($0.contentIdentifier) }
    }

    func item(at index: Int) -> HomepageInterfaceItemViewModel {
        guard index < content.count else { return EmptyHomepageItemViewModel() }
        return content[index]
    }

}

struct EmptyHomepageItemViewModel: HomepageInterfaceItemViewModel {

    var title: String = ""

}

struct HomepageItemViewModel: HomepageInterfaceItemViewModel {

    var item: HomepageItem

    var title: String {
        return item.title
    }

}
