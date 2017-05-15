//
//  PhoneApp.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 14/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

class PhoneApp: App, HomepageServiceLoadingDelegate {

    var rootRouter: RootRouter
    var homepageService: HomepageService
    var homepageInterface: HomepageInterface?

    init(rootRouter: RootRouter, homepageService: HomepageService) {
        self.rootRouter = rootRouter
        self.homepageService = homepageService
    }

    func launch() {
        homepageInterface = rootRouter.navigateToHomepage().interface
        homepageService.loadHomepage(delegate: self)
    }

    func homepageDidLoadSuccessfully() {
        homepageInterface?.prepareForUpdates()
    }

    func homepageDidFailToLoad() {

    }

}
