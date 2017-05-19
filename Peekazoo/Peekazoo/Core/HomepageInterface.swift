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

protocol HomepageInterface {

    var delegate: HomepageInterfaceDelegate? { get set }

    func updateInterface(viewModel: HomepageInterfaceViewModel, applyingDifferences diffs: [Difference])
    func showLoadingErrorPlaceholder()
    func hideLoadingErrorPlaceholder()
    func showNoContentPlaceholder()
    func hideNoContentPlaceholder()

}
