//
//  CapturingRootRouter.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 14/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo
import UIKit

class CapturingRootRouter: RootRouter {

    private(set) var didNavigateToRoot = false
    func navigateToRoot() -> (viewController: UIViewController, router: Any) {
        didNavigateToRoot = true
        return (viewController: UIViewController(), router: "")
    }

}
