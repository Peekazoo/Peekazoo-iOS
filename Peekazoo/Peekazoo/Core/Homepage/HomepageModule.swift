//
//  HomepageModule.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 15/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

class HomepageModule {

    class func initialize(router: RootRouter, service: HomepageService) {
        let homepageInterface = router.navigateToHomepage().interface
        _ = HomepagePresenter(interface: homepageInterface, service: service)
    }

}
