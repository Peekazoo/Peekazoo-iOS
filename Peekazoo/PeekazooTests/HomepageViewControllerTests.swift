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

    var homepageViewController: HomepageViewController!

    override func setUp() {
        super.setUp()

        homepageViewController = HomepageViewController()
        homepageViewController.loadViewIfNeeded()
    }

    func testHasHomeAsTheTitle() {
        XCTAssertEqual("Home", homepageViewController.title)
    }

    func testHasCollectionView() {
        XCTAssertNotNil(homepageViewController.collectionView)
    }

    func testHaveZeroSectionsInTheCollectionViewBeforeLoading() {
        XCTAssertEqual(0, homepageViewController.collectionView?.numberOfSections)
    }

    func testUpdatingInterfaceUpdatesNumberOfSectionsToOne() {
        let item = StubHomepageInterfaceItemViewModel()
        let viewModel = StubHomepageInterfaceViewModel(items: [item])
        homepageViewController.updateInterface(viewModel: viewModel, applyingDifferences: [])

        XCTAssertEqual(1, homepageViewController.collectionView?.numberOfSections)
    }

    func testUpdatingInterfaceUpdatesNumberOfItemsToCountFromViewModel() {
        let count = Int(arc4random_uniform(100))
        let items = Array(repeating: StubHomepageInterfaceItemViewModel(), count: count)
        let insertions = (0..<count).map({ Difference.insertion(index: $0) })
        let viewModel = StubHomepageInterfaceViewModel(items: items)
        homepageViewController.updateInterface(viewModel: viewModel, applyingDifferences: insertions)

        XCTAssertEqual(count, homepageViewController.collectionView?.numberOfItems(inSection: 0))
    }

}
