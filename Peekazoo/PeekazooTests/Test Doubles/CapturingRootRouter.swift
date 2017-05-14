//
//  CapturingRootRouter.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 14/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo

class CapturingRootRouter: RootRouter {

    private(set) var didNavigateToRoot = false
    func navigateToRoot() -> (interface: Any, router: Any) {
        didNavigateToRoot = true
        return (interface: "", router: "")
    }

}
