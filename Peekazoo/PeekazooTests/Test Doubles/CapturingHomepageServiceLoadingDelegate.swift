//
//  CapturingHomepageServiceLoadingDelegate.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 16/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo

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

}
