//
//  HomepageViewControllerTests.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 14/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo
import XCTest

class HomepageViewControllerTests: XCTestCase {

    func testHasHomeAsTheTitle() {
        let homepageViewController = HomepageViewController()
        homepageViewController.loadViewIfNeeded()

        XCTAssertEqual("Home", homepageViewController.title)
    }

    func testHasCollectionView() {
        let homepageViewController = HomepageViewController()
        homepageViewController.loadViewIfNeeded()

        XCTAssertNotNil(homepageViewController.collectionView)
    }

}
