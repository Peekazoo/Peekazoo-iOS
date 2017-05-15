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
    func hideLoadingErrorPlaceholder() { }
    func showNoContentPlaceholder() { }
    func hideNoContentPlaceholder() { }
    func insertItem(at index: Int) { }

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

    private(set) var didHideLoadingErrorPlaceholder = false
    func hideLoadingErrorPlaceholder() {
        didHideLoadingErrorPlaceholder = true
    }

    private(set) var didShowNoContentPlaceholder = false
    func showNoContentPlaceholder() {
        didShowNoContentPlaceholder = true
    }

    private(set) var didHideNoContentPlaceholder = false
    func hideNoContentPlaceholder() {
        didHideNoContentPlaceholder = true
    }

    private(set) var insertedItemIndex: Int?
    func insertItem(at index: Int) {
        insertedItemIndex = index
    }

    func invokePullToRefresh() {
        delegate?.homepageInterfaceDidInvokePullToRefresh()
    }

}

class TimedInvocationHomepageInterface: CapturingHomepageInterface {

    var prepareForUpdatesHandler: (() -> Void)?
    override func prepareForUpdates() {
        super.prepareForUpdates()
        prepareForUpdatesHandler?()
    }

}
