//
//  HomepageModule.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 15/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

struct HomepageModule {

    static func initialize(router: RootRouter,
                           service: HomepageService,
                           timeFormatter: TimeFormatter) {
        let homepageInterface = router.navigateToHomepage().interface
        _ = HomepagePresenter(interface: homepageInterface,
                              service: service,
                              timeFormatter: timeFormatter)
    }

}
