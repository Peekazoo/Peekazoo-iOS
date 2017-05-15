//
//  PhoneApp.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 14/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

struct PhoneApp: App {

    var rootRouter: RootRouter
    var homepageService: HomepageService

    init(rootRouter: RootRouter, homepageService: HomepageService) {
        self.rootRouter = rootRouter
        self.homepageService = homepageService
    }

    func launch() {
        let routing = rootRouter.navigateToHomepage()
        homepageService.loadHomepage()
        routing.interface.prepareForUpdates()
    }

}
