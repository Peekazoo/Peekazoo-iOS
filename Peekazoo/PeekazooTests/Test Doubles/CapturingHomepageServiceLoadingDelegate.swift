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
    func homepageServiceDidLoadSuccessfully(content: [HomepageItem]) {
        didFinishLoadingInvoked = true
    }

    private(set) var didFailToLoadInvoked = false
    func homepageServiceDidFailToLoad() {
        didFailToLoadInvoked = true
    }

}
