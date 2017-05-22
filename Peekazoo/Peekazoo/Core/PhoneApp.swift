//
//  PhoneApp.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 14/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

public struct PhoneApp: App {

    private var rootRouter: RootRouter
    private var homepageService: HomepageService

    public init(rootRouter: RootRouter, homepageService: HomepageService) {
        self.rootRouter = rootRouter
        self.homepageService = homepageService
    }

    public func launch() {
        HomepageModule.initialize(router: rootRouter, service: homepageService)
    }

}
