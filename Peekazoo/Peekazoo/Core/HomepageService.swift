//
//  HomepageService.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 15/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

protocol HomepageServiceLoadingDelegate {

    func homepageServiceDidLoadSuccessfully(content: [HomepageItem])
    func homepageServiceDidFailToLoad()

}

protocol HomepageItem {

    var contentIdentifier: String { get }
    var title: String { get }

}

protocol HomepageService {

    func loadHomepage(delegate: HomepageServiceLoadingDelegate)

}
