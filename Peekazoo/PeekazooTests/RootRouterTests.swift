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
    
    func testSetNavigationControllerAsTheRootViewController() {
        let window = UIWindow()
        let router = RootRouter(window: window)
        _ = router.navigateToRoot()
        
        XCTAssertTrue(window.rootViewController is UINavigationController)
    }
    
    func testSetTheHomepageViewControllerAsTheTopViewControllerOnTheRoot() {
        let window = UIWindow()
        let router = RootRouter(window: window)
        _ = router.navigateToRoot()
        
        XCTAssertTrue((window.rootViewController as? UINavigationController)?.topViewController is HomepageViewController)
    }
    
    func testReturnTheHomepageViewController() {
        let window = UIWindow()
        let router = RootRouter(window: window)
        let presented = router.navigateToRoot().viewController
        
        XCTAssertEqual(presented, (window.rootViewController as? UINavigationController)?.topViewController)
    }
    
    func testReturnTheHomepageRouter() {
        let window = UIWindow()
        let router = RootRouter(window: window)
        let homepageRouter = router.navigateToRoot().router
        
        XCTAssertTrue(homepageRouter is HomepageRouter)
    }
    
}
