//
//  PhoneApp.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 14/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

class PhoneApp: App {

    var rootRouter: RootRouter
    var homepageService: HomepageService
    var homepagePresenter: HomepagePresenter?

    init(rootRouter: RootRouter, homepageService: HomepageService) {
        self.rootRouter = rootRouter
        self.homepageService = homepageService
    }

    func launch() {
        let homepageInterface = rootRouter.navigateToHomepage().interface
        homepagePresenter = HomepagePresenter(homepageInterface: homepageInterface, homepageService: homepageService)
    }

}
