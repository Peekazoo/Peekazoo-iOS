//
//  PhoneApp.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 14/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

struct PhoneApp: App {

    var rootRouter: RootRouter
    var homepageService: HomepageService

    init(rootRouter: RootRouter, homepageService: HomepageService) {
        self.rootRouter = rootRouter
        self.homepageService = homepageService
    }

    func launch() {
        HomepageModule.initialize(router: rootRouter, service: homepageService)
    }

}
