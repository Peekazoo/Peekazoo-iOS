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

    override func setUp() {
        super.setUp()
        appDelegate = AppDelegate()
    }
    
    private func simulateAppDidFinishLaunching() {
        _ = appDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: [:])
    }

    func testTheWindowShouldExist() {
        XCTAssertNotNil(appDelegate.window)
    }

    func testWhenApplicationDidFinishLaunchingTheAppFactoryShouldBeAskedToCreateTheApp() {
        let capturingAppFactory = CapturingAppFactory()
        appDelegate.appFactory = capturingAppFactory
        simulateAppDidFinishLaunching()

        XCTAssertTrue(capturingAppFactory.didMakeApplication)
    }

    func testWhenApplicationDidFinishLaunchingTheAppFactoryShouldUseTheWindowWhenMakingCore() {
        let capturingAppFactory = CapturingAppFactory()
        appDelegate.appFactory = capturingAppFactory
        simulateAppDidFinishLaunching()

        XCTAssertEqual(appDelegate.window, capturingAppFactory.capturedWindow)
    }

    func testWhenApplicationDidFinishLaunchingTheAppFromTheFactoryShouldBeToldToLaunch() {
        let capturingApp = CapturingApp()
        let stubbedAppFactory = StubAppFactory(app: capturingApp)
        appDelegate.appFactory = stubbedAppFactory
        simulateAppDidFinishLaunching()

        XCTAssertTrue(capturingApp.didLaunch)
    }

    func testWhenApplicationDidFinishLaunchingTheAppFromTheFactoryShouldBeRetained() {
        let capturingApp = CapturingApp()
        let stubbedAppFactory = StubAppFactory(app: capturingApp)
        appDelegate.appFactory = stubbedAppFactory
        simulateAppDidFinishLaunching()

        XCTAssertTrue((appDelegate.app as? CapturingApp) === capturingApp)
    }

    func testTheDefaultAppFactoryShouldBeUsed() {
        XCTAssertTrue(appDelegate.appFactory is PhoneAppFactory)
    }

}
