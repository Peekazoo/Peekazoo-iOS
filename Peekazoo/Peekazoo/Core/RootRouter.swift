//
//  RootRouter.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 14/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

public protocol RootRouter {

    func navigateToHomepage() -> (interface: HomepageInterface, router: Any)

}
