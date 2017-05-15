//
//  HomepageInterface.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 15/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

protocol HomepageInterfaceDelegate {

    func homepageDidInvokePullToRefresh()

}

protocol HomepageInterface {

    var delegate: HomepageInterfaceDelegate? { get set }

    func prepareForUpdates()
    func showLoadingErrorPlaceholder()

}
