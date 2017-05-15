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

    private func cellForItem(at index: Int) -> HomepageItemCollectionViewCell? {
        let indexPath = IndexPath(item: index, section: 0)
        let cell = homepageViewController.collectionView.cellForItem(at: indexPath)
        return cell as? HomepageItemCollectionViewCell
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

    func testDequeuedHomepageItemCellsShouldHaveLabels() {
        let item = StubHomepageInterfaceItemViewModel()
        let viewModel = StubHomepageInterfaceViewModel(items: [item])
        updateInterface(viewModel: viewModel, applyingDifferences: [])

        XCTAssertNotNil(cellForItem(at: 0)?.itemTitleLabel)
    }

    func testDequeuedItemCellShouldBeConfiguredWithTheTitleFromTheViewModel() {
        let item = StubHomepageInterfaceItemViewModel(title: "Some title")
        let viewModel = StubHomepageInterfaceViewModel(items: [item])
        updateInterface(viewModel: viewModel, applyingDifferences: [])

        XCTAssertEqual(item.title, cellForItem(at: 0)?.itemTitleLabel.text)
    }

    func testDequeuedItemsShouldBeProvidedWithCorrectTitlesFromViewModel() {
        let firstItem = StubHomepageInterfaceItemViewModel(title: "Some title")
        let secondItem = StubHomepageInterfaceItemViewModel(title: "Some other title")
        let viewModel = StubHomepageInterfaceViewModel(items: [firstItem, secondItem])
        updateInterface(viewModel: viewModel, applyingDifferences: [])

        XCTAssertEqual(secondItem.title, cellForItem(at: 1)?.itemTitleLabel.text)
    }

}
