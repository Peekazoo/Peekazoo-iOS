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

    @discardableResult private func navigateToHomepage() -> (interface: HomepageInterface, router: Any) {
        return router.navigateToHomepage()
    }

    private var expectedRootNavigationController: UINavigationController? {
        return window.rootViewController as? UINavigationController
    }

    func testSetNavigationControllerAsTheRootViewController() {
        navigateToHomepage()
        XCTAssertTrue(window.rootViewController is UINavigationController)
    }

    func testSetTheHomepageViewControllerAsTheTopViewControllerOnTheRoot() {
        navigateToHomepage()
        XCTAssertTrue(expectedRootNavigationController?.topViewController is HomepageViewController)
    }

    func testReturnTheHomepageViewController() {
        let presented = navigateToHomepage().interface
        XCTAssertEqual(presented as? UIViewController, expectedRootNavigationController?.topViewController)
    }

    func testReturnTheHomepageRouter() {
        let homepageRouter = navigateToHomepage().router
        XCTAssertTrue(homepageRouter is HomepageRouter)
    }

    func testMakeTheWindowVisible() {
        navigateToHomepage()
        XCTAssertFalse(window.isHidden)
    }

    func testMakeTheWindowKey() {
        navigateToHomepage()
        XCTAssertTrue(window.isKeyWindow)
    }

}
