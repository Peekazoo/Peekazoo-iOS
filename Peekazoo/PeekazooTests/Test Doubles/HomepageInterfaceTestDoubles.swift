//
//  DummyHomepageInterface.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 15/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo

class DummyHomepageInterface: HomepageInterface {

    func prepareForUpdates() { }
    func showLoadingErrorPlaceholder() { }

}

class CapturingHomepageInterface: HomepageInterface {

    private(set) var didPrepareForUpdates = false
    func prepareForUpdates() {
        didPrepareForUpdates = true
    }

    private(set) var didShowLoadingErrorPlaceholder = false
    func showLoadingErrorPlaceholder() {
        didShowLoadingErrorPlaceholder = true
    }

}
