//
//  DummyHomepageInterface.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 15/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo

class DummyHomepageInterface: HomepageInterface {

    var delegate: HomepageInterfaceDelegate?

    func prepareForUpdates() { }
    func showLoadingErrorPlaceholder() { }
    func showNoContentPlaceholder() { }
    func hideNoContentPlaceholder() { }

}

class CapturingHomepageInterface: HomepageInterface {

    var delegate: HomepageInterfaceDelegate?

    private(set) var didPrepareForUpdates = false
    func prepareForUpdates() {
        didPrepareForUpdates = true
    }

    private(set) var didShowLoadingErrorPlaceholder = false
    func showLoadingErrorPlaceholder() {
        didShowLoadingErrorPlaceholder = true
    }

    private(set) var didShowNoContentPlaceholder = false
    func showNoContentPlaceholder() {
        didShowNoContentPlaceholder = true
    }

    private(set) var didHideNoContentPlaceholder = false
    func hideNoContentPlaceholder() {
        didHideNoContentPlaceholder = true
    }

    func invokePullToRefresh() {
        delegate?.homepageInterfaceDidInvokePullToRefresh()
    }

}
