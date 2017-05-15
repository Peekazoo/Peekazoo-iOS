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
        let count = Int.random(upperLimit: 100)
        let items = Array(repeating: StubHomepageInterfaceItemViewModel(), count: count)
        let insertions = (0..<count).map({ Difference.insertion(index: $0) })
        let viewModel = StubHomepageInterfaceViewModel(items: items)
        homepageViewController.updateInterface(viewModel: viewModel, applyingDifferences: insertions)

        XCTAssertEqual(count, homepageViewController.collectionView?.numberOfItems(inSection: 0))
    }

    func testDequeueingCellAfterSupplyingContentShouldProvideHomepageItemCell() {
        let item = StubHomepageInterfaceItemViewModel()
        let viewModel = StubHomepageInterfaceViewModel(items: [item])
        homepageViewController.updateInterface(viewModel: viewModel, applyingDifferences: [])
        homepageViewController.collectionView.layoutIfNeeded()
        let cell = homepageViewController.collectionView.cellForItem(at: IndexPath(item: 0, section: 0))

        XCTAssertTrue(cell is HomepageItemCollectionViewCell)
    }

    func testDequeuedHomepageItemCellsShouldHaveLabels() {
        let item = StubHomepageInterfaceItemViewModel()
        let viewModel = StubHomepageInterfaceViewModel(items: [item])
        homepageViewController.updateInterface(viewModel: viewModel, applyingDifferences: [])
        homepageViewController.collectionView.layoutIfNeeded()
        let cell = homepageViewController.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? HomepageItemCollectionViewCell

        XCTAssertNotNil(cell?.itemTitleLabel)
    }

    func testDequeuedItemCellShouldBeConfiguredWithTheTitleFromTheViewModel() {
        let item = StubHomepageInterfaceItemViewModel(title: "Some title")
        let viewModel = StubHomepageInterfaceViewModel(items: [item])
        homepageViewController.updateInterface(viewModel: viewModel, applyingDifferences: [])
        homepageViewController.collectionView.layoutIfNeeded()
        let cell = homepageViewController.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? HomepageItemCollectionViewCell

        XCTAssertEqual(item.title, cell?.itemTitleLabel.text)
    }

}
