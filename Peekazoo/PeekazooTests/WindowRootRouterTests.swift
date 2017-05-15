//
//  WindowRootRouterTests.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 13/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo
import XCTest

class WindowRootRouterTests: XCTestCase {

    var window: UIWindow!
    var router: WindowRootRouter!

    override func setUp() {
        super.setUp()

        window = UIWindow()
        router = WindowRootRouter(window: window)
    }

    func testSetNavigationControllerAsTheRootViewController() {
        _ = router.navigateToHomepage()
        XCTAssertTrue(window.rootViewController is UINavigationController)
    }

    func testSetTheHomepageViewControllerAsTheTopViewControllerOnTheRoot() {
        _ = router.navigateToHomepage()
        XCTAssertTrue((window.rootViewController as? UINavigationController)?.topViewController is HomepageViewController)
    }

    func testReturnTheHomepageViewController() {
        let presented = router.navigateToHomepage().interface
        XCTAssertEqual((presented as? UIViewController), (window.rootViewController as? UINavigationController)?.topViewController)
    }

    func testReturnTheHomepageRouter() {
        let homepageRouter = router.navigateToHomepage().router
        XCTAssertTrue(homepageRouter is HomepageRouter)
    }

    func testMakeTheWindowVisible() {
        _ = router.navigateToHomepage()
        XCTAssertFalse(window.isHidden)
    }

    func testMakeTheWindowKey() {
        _ = router.navigateToHomepage()
        XCTAssertTrue(window.isKeyWindow)
    }

}
