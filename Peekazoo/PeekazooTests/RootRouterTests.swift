//
//  RootRouterTests.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 13/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo
import XCTest

class RootRouterTests: XCTestCase {
    
    func testTheRouterShouldSetTheRootViewControllerOntoTheWindow() {
        let window = UIWindow()
        let router = RootRouter(window: window)
        router.navigateToRoot()
        
        XCTAssertNotNil(window.rootViewController)
    }
    
}
