//
//  CapturingRootRouter.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 14/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo

class CapturingRootRouter: RootRouter {

    private(set) var didNavigateToHomepage = false
    var stubHomepageInterface: HomepageInterface = DummyHomepageInterface()
    func navigateToHomepage() -> (interface: HomepageInterface, router: Any) {
        didNavigateToHomepage = true
        return (interface: stubHomepageInterface, router: "")
    }

}
