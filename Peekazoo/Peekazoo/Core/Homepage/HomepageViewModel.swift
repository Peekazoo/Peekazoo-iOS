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
    var timeFormatter: TimeFormatter

    init(timeFormatter: TimeFormatter) {
        self.timeFormatter = timeFormatter
    }

    var numberOfItems: Int {
        return content.count
    }

    mutating func union(items: [HomepageItem]) {
        let existingIdentifiers = content.map({ $0.item.contentIdentifier })
        let newItems = items.filter(isNotRepresentedByExistingIdentifiers(existingIdentifiers))
        content = newItems.map(makeItemViewModel) + content
        sortByCreationDate()
    }

    private func isNotRepresentedByExistingIdentifiers(_ identifiers: [String]) -> (HomepageItem) -> Bool {
        return { !identifiers.contains($0.contentIdentifier) }
    }

    private func makeItemViewModel(_ item: HomepageItem) -> HomepageItemViewModel {
        return HomepageItemViewModel(item: item, timeFormatter: timeFormatter)
    }

    private mutating func sortByCreationDate() {
        content.sort { (first, second) -> Bool in
            return first.item.creationDate.compare(second.item.creationDate) == .orderedDescending
        }
    }

    func item(at index: Int) -> HomepageInterfaceItemViewModel {
        guard index < content.count else { return EmptyHomepageItemViewModel() }
        return content[index]
    }

}

struct EmptyHomepageItemViewModel: HomepageInterfaceItemViewModel {

    var title: String = ""
    var creationDate: String = ""

}

struct HomepageItemViewModel: HomepageInterfaceItemViewModel {

    var item: HomepageItem
    var timeFormatter: TimeFormatter

    var title: String {
        return item.title
    }

    var creationDate: String {
        return timeFormatter.string(from: item.creationDate)
    }

}
