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

    func updateInterface(viewModel: HomepageInterfaceViewModel, applyingDifferences diffs: [Difference]) { }
    func showLoadingErrorPlaceholder() { }
    func hideLoadingErrorPlaceholder() { }
    func showNoContentPlaceholder() { }
    func hideNoContentPlaceholder() { }

}

class CapturingHomepageInterface: HomepageInterface {

    var delegate: HomepageInterfaceDelegate?

    private(set) var committedViewModel: HomepageInterfaceViewModel?
    private(set) var insertedItemIndex: Int?
    func updateInterface(viewModel: HomepageInterfaceViewModel, applyingDifferences diffs: [Difference]) {
        committedViewModel = viewModel

        if let diff = diffs.first {
            insertedItemIndex = diff.insertedIndex
        }
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

    fileprivate func extractIndex(from diff: Difference) -> Int? {
        if case .insertion(let idx) = diff {
            return idx
        } else {
            return nil
        }
    }

}

class JournallingIndexHomepageInterface: CapturingHomepageInterface {

    private(set) var indicies = [Int]()
    override func updateInterface(viewModel: HomepageInterfaceViewModel, applyingDifferences diffs: [Difference]) {
        super.updateInterface(viewModel: viewModel, applyingDifferences: diffs)
        indicies = diffs.flatMap({ $0.insertedIndex })
    }

}
