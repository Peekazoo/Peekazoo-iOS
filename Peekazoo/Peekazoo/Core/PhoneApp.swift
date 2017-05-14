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

    init(rootRouter: RootRouter) {
        self.rootRouter = rootRouter
    }

    func launch() {
        _ = rootRouter.navigateToRoot()
    }

}
