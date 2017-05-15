//
//  WindowRootRouter.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 13/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import UIKit

struct WindowRootRouter: RootRouter {

    var window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func navigateToHomepage() -> (interface: Any, router: Any) {
        let homepage = HomepageViewController()
        window.rootViewController = UINavigationController(rootViewController: homepage)
        window.makeKeyAndVisible()

        return (interface: homepage, router: HomepageRouter())
    }

}
