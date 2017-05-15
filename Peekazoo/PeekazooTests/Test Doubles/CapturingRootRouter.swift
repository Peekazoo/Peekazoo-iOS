//
//  CapturingRootRouter.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 14/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo

class StubRootRouter: RootRouter {

    var stubHomepageInterface: HomepageInterface = DummyHomepageInterface()
    func navigateToHomepage() -> (interface: HomepageInterface, router: Any) {
        return (interface: stubHomepageInterface, router: "")
    }

}

class CapturingRootRouter: StubRootRouter {

    private(set) var didNavigateToHomepage = false
    override func navigateToHomepage() -> (interface: HomepageInterface, router: Any) {
        didNavigateToHomepage = true
        return super.navigateToHomepage()
    }

}
