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

    private func updateInterface(viewModel: HomepageInterfaceViewModel, applyingDifferences diffs: [Difference]) {
        homepageViewController.updateInterface(viewModel: viewModel, applyingDifferences: [])
        homepageViewController.collectionView.layoutIfNeeded()
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
        updateInterface(viewModel: viewModel, applyingDifferences: [])

        XCTAssertEqual(1, homepageViewController.collectionView?.numberOfSections)
    }

    func testUpdatingInterfaceUpdatesNumberOfItemsToCountFromViewModel() {
        let count = Int.random(upperLimit: 100)
        let items = Array(repeating: StubHomepageInterfaceItemViewModel(), count: count)
        let insertions = (0..<count).map({ Difference.insertion(index: $0) })
        let viewModel = StubHomepageInterfaceViewModel(items: items)
        updateInterface(viewModel: viewModel, applyingDifferences: insertions)

        XCTAssertEqual(count, homepageViewController.collectionView?.numberOfItems(inSection: 0))
    }

    func testDequeueingCellAfterSupplyingContentShouldProvideHomepageItemCell() {
        let item = StubHomepageInterfaceItemViewModel()
        let viewModel = StubHomepageInterfaceViewModel(items: [item])
        updateInterface(viewModel: viewModel, applyingDifferences: [])
        let cell = homepageViewController.collectionView.cellForItem(at: IndexPath(item: 0, section: 0))

        XCTAssertTrue(cell is HomepageItemCollectionViewCell)
    }

    func testDequeuedHomepageItemCellsShouldHaveLabels() {
        let item = StubHomepageInterfaceItemViewModel()
        let viewModel = StubHomepageInterfaceViewModel(items: [item])
        updateInterface(viewModel: viewModel, applyingDifferences: [])
        let cell = homepageViewController.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? HomepageItemCollectionViewCell

        XCTAssertNotNil(cell?.itemTitleLabel)
    }

    func testDequeuedItemCellShouldBeConfiguredWithTheTitleFromTheViewModel() {
        let item = StubHomepageInterfaceItemViewModel(title: "Some title")
        let viewModel = StubHomepageInterfaceViewModel(items: [item])
        updateInterface(viewModel: viewModel, applyingDifferences: [])
        let cell = homepageViewController.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? HomepageItemCollectionViewCell

        XCTAssertEqual(item.title, cell?.itemTitleLabel.text)
    }

    func testDequeuedItemsShouldBeProvidedWithCorrectTitlesFromViewModel() {
        let firstItem = StubHomepageInterfaceItemViewModel(title: "Some title")
        let secondItem = StubHomepageInterfaceItemViewModel(title: "Some other title")
        let viewModel = StubHomepageInterfaceViewModel(items: [firstItem, secondItem])
        updateInterface(viewModel: viewModel, applyingDifferences: [])
        let cell = homepageViewController.collectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as? HomepageItemCollectionViewCell

        XCTAssertEqual(secondItem.title, cell?.itemTitleLabel.text)
    }

}
