//
//  PeekazooServiceProtocol.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 19/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

protocol PeekazooServiceProtocol {

    func loadHomepage(delegate: HomepageLoadingDelegate)

}

protocol HomepageLoadingDelegate {

    func finishedLoadingHomepage(items: [HomepageItem])
    func failedToLoadHomepage()

}
