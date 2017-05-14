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

    var window: UIWindow!
    var router: RootRouter!

    override func setUp() {
        super.setUp()

        window = UIWindow()
        router = RootRouter(window: window)
    }

    func testSetNavigationControllerAsTheRootViewController() {
        _ = router.navigateToRoot()
        XCTAssertTrue(window.rootViewController is UINavigationController)
    }

    func testSetTheHomepageViewControllerAsTheTopViewControllerOnTheRoot() {
        _ = router.navigateToRoot()
        XCTAssertTrue((window.rootViewController as? UINavigationController)?.topViewController is HomepageViewController)
    }

    func testReturnTheHomepageViewController() {
        let presented = router.navigateToRoot().viewController
        XCTAssertEqual(presented, (window.rootViewController as? UINavigationController)?.topViewController)
    }

    func testReturnTheHomepageRouter() {
        let homepageRouter = router.navigateToRoot().router
        XCTAssertTrue(homepageRouter is HomepageRouter)
    }

    func testMakeTheWindowVisible() {
        _ = router.navigateToRoot()
        XCTAssertFalse(window.isHidden)
    }

}
