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
    
    func testSetNavigationControllerAsTheRootViewController() {
        let window = UIWindow()
        let router = RootRouter(window: window)
        router.navigateToRoot()
        
        XCTAssertTrue(window.rootViewController is UINavigationController)
    }
    
    func testSetTheHomepageViewControllerAsTheTopViewControllerOnTheRoot() {
        let window = UIWindow()
        let router = RootRouter(window: window)
        router.navigateToRoot()
        
        XCTAssertTrue((window.rootViewController as? UINavigationController)?.topViewController is HomepageViewController)
    }
    
}
