//
//  CapturingHomepageLoadingDelegate.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 20/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo

class CapturingHomepageLoadingDelegate: HomepageLoadingDelegate {

    private(set) var didFinishLoadingInvoked = false
    private(set) var capturedHomepageItems: [HomepageItem]?
    func finishedLoadingHomepage(items: [HomepageItem]) {
        didFinishLoadingInvoked = true
        capturedHomepageItems = items
    }

    private(set) var didFailToLoadInvoked = false
    func failedToLoadHomepage() {
        didFailToLoadInvoked = true
    }

    func capturedItemsEqual<T>(to items: [T]) -> Bool where T: HomepageItem, T: Equatable {
        guard let castedItems = capturedHomepageItems as? [T] else { return false }
        return items.elementsEqual(castedItems)
    }

}
