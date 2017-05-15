//
//  HomepageInterface.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 15/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

protocol HomepageInterfaceDelegate {

    func homepageInterfaceDidInvokePullToRefresh()

}

protocol HomepageInterfaceViewModel {

    var numberOfItems: Int { get }

    func item(at index: Int) -> HomepageInterfaceItemViewModel

}

protocol HomepageInterfaceItemViewModel {

    var title: String { get }

}

enum Difference {
    case insertion(index: Int)
}

protocol HomepageInterface {

    var delegate: HomepageInterfaceDelegate? { get set }

    func updateInterface(viewModel: HomepageInterfaceViewModel, applyingDifferences diffs: [Difference])
    func showLoadingErrorPlaceholder()
    func hideLoadingErrorPlaceholder()
    func showNoContentPlaceholder()
    func hideNoContentPlaceholder()

}
