//
//  HomepageViewControllerTests.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 14/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo
import XCTest

struct StubHomepageInterfaceViewModel: HomepageInterfaceViewModel {

    init(items: [StubHomepageInterfaceItemViewModel]) {
        self.items = items
    }

    var items: [StubHomepageInterfaceItemViewModel]
    var numberOfItems: Int { return items.count }

    func item(at index: Int) -> HomepageInterfaceItemViewModel {
        return items[index]
    }

}

struct StubHomepageInterfaceItemViewModel: HomepageInterfaceItemViewModel {

    var title: String = ""

}

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

    func testHaveZeroSectionsInTheCollectionViewBeforeLoading() {
        let homepageViewController = HomepageViewController()
        homepageViewController.loadViewIfNeeded()

        XCTAssertEqual(0, homepageViewController.collectionView?.numberOfSections)
    }

    func testUpdatingInterfaceUpdatesNumberOfSectionsToOne() {
        let homepageViewController = HomepageViewController()
        homepageViewController.loadViewIfNeeded()
        let item = StubHomepageInterfaceItemViewModel()
        let viewModel = StubHomepageInterfaceViewModel(items: [item])
        homepageViewController.updateInterface(viewModel: viewModel, applyingDifferences: [])

        XCTAssertEqual(1, homepageViewController.collectionView?.numberOfSections)
    }

}
