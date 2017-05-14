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
    
    func testTheWindowShouldExist() {
        let appDelegate = AppDelegate()
        XCTAssertNotNil(appDelegate.window)
    }
    
    func testWhenApplicationDidFinishLaunchingTheAppFactoryShouldBeAskedToCreateTheApp() {
        let appDelegate = AppDelegate()
        let capturingAppFactory = CapturingAppFactory()
        appDelegate.appFactory = capturingAppFactory
        _ = appDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: [:])
        
        XCTAssertTrue(capturingAppFactory.didMakeApplication)
    }
    
}
