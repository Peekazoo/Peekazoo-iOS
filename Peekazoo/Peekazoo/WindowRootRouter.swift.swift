//
//  WindowRootRouter.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 13/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import UIKit

public struct WindowRootRouter: RootRouter {

    private var window: UIWindow

    public init(window: UIWindow) {
        self.window = window
    }

    public func navigateToHomepage() -> (interface: HomepageInterface, router: Any) {
        let homepage = HomepageViewController()
        window.rootViewController = UINavigationController(rootViewController: homepage)
        window.makeKeyAndVisible()

        return (interface: homepage, router: HomepageRouter())
    }

}
