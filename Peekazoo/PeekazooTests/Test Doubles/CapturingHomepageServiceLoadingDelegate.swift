//
//  CapturingHomepageServiceLoadingDelegate.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 16/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Peekazoo

class CapturingHomepageServiceLoadingDelegate: HomepageServiceLoadingDelegate {

    private(set) var didFinishLoadingInvoked = false
    private(set) var capturedHomepageItems: [HomepageItem]?
    func homepageServiceDidLoadSuccessfully(content: [HomepageItem]) {
        didFinishLoadingInvoked = true
        capturedHomepageItems = content
    }

    private(set) var didFailToLoadInvoked = false
    func homepageServiceDidFailToLoad() {
        didFailToLoadInvoked = true
    }

    func capturedItemsEqual<T>(to items: [T]) -> Bool where T: HomepageItem, T: Equatable {
        guard let castedItems = capturedHomepageItems as? [T] else { return false }
        return items.elementsEqual(castedItems)
    }

}
