//
//  HomepageService.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 15/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

public protocol HomepageServiceLoadingDelegate {

    func homepageServiceDidLoadSuccessfully(content: [HomepageItem])
    func homepageServiceDidFailToLoad()

}

public protocol HomepageItem {

    var contentIdentifier: String { get }
    var title: String { get }

}

public protocol HomepageService {

    func loadHomepage(delegate: HomepageServiceLoadingDelegate)

}
