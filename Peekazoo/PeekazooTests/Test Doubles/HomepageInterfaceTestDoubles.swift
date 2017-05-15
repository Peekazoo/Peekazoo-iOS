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
    func insertItem(at index: Int) { }
    func commitUpdates(using viewModel: HomepageInterfaceViewModel) { }
    func showLoadingErrorPlaceholder() { }
    func hideLoadingErrorPlaceholder() { }
    func showNoContentPlaceholder() { }
    func hideNoContentPlaceholder() { }

}

class CapturingHomepageInterface: HomepageInterface {

    var delegate: HomepageInterfaceDelegate?

    private(set) var didPrepareForUpdates = false
    func prepareForUpdates() {
        didPrepareForUpdates = true
    }

    private(set) var insertedItemIndex: Int?
    func insertItem(at index: Int) {
        insertedItemIndex = index
    }

    private(set) var didCommitUpdates = false
    private(set) var committedViewModel: HomepageInterfaceViewModel?
    func commitUpdates(using viewModel: HomepageInterfaceViewModel) {
        didCommitUpdates = true
        committedViewModel = viewModel
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

    func invokePullToRefresh() {
        delegate?.homepageInterfaceDidInvokePullToRefresh()
    }

}

class DetectIndexInsertionBeforePreparingMock: CapturingHomepageInterface {

    private(set) var wasToldToPrepareAfterAlreadyInsertingIndex = false
    override func prepareForUpdates() {
        super.prepareForUpdates()
        wasToldToPrepareAfterAlreadyInsertingIndex = insertedItemIndex != nil
    }

}

class JournallingIndexHomepageInterface: CapturingHomepageInterface {

    private(set) var indicies = [Int]()
    override func insertItem(at index: Int) {
        super.insertItem(at: index)
        indicies.append(index)
    }

}
