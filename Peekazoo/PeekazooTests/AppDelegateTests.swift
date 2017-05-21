//
//  AppDelegateTests.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 13/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo
import XCTest

class AppDelegateTests: XCTestCase {

    var appDelegate: AppDelegate!
    var capturingApp: CapturingApp!
    var capturingAppFactory: CapturingAppFactory!

    override func setUp() {
        super.setUp()

        capturingApp = CapturingApp()
        capturingAppFactory = CapturingAppFactory(app: capturingApp)
        appDelegate = AppDelegate()
        appDelegate.appFactory = capturingAppFactory
    }

    private func simulateAppDidFinishLaunching() {
        _ = appDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: [:])
    }

    func testTheWindowShouldExist() {
        XCTAssertNotNil(appDelegate.window)
    }

    func testWhenApplicationDidFinishLaunchingTheAppFactoryShouldBeAskedToCreateTheApp() {
        simulateAppDidFinishLaunching()
        XCTAssertTrue(capturingAppFactory.didMakeApplication)
    }

    func testWhenApplicationDidFinishLaunchingTheAppFactoryShouldUseTheWindowWhenMakingCore() {
        simulateAppDidFinishLaunching()
        XCTAssertEqual(appDelegate.window, capturingAppFactory.capturedWindow)
    }

    func testWhenApplicationDidFinishLaunchingTheAppFromTheFactoryShouldBeToldToLaunch() {
        simulateAppDidFinishLaunching()
        XCTAssertTrue(capturingApp.didLaunch)
    }

    func testWhenApplicationDidFinishLaunchingTheAppFromTheFactoryShouldBeRetained() {
        simulateAppDidFinishLaunching()
        XCTAssertTrue((appDelegate.app as? CapturingApp) === capturingApp)
    }

    func testTheDefaultAppFactoryShouldBeUsed() {
        XCTAssertTrue(AppDelegate().appFactory is PhoneAppFactory)
    }

}
