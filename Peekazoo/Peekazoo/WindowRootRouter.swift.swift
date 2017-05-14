//
//  WindowRootRouter.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 13/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import UIKit

struct WindowRootRouter {

    var window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func navigateToRoot() -> (viewController: UIViewController, router: Any) {
        let homepage = HomepageViewController()
        window.rootViewController = UINavigationController(rootViewController: homepage)
        window.makeKeyAndVisible()

        return (viewController: homepage, router: HomepageRouter())
    }

}
