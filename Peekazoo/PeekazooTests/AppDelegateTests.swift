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
    
}
