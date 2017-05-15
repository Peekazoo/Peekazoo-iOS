//
//  PhoneAppTests.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 14/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo
import XCTest

class PhoneAppTests: XCTestCase {

    struct PhoneAppTestBuilder {

        struct Product<Interface> where Interface: HomepageInterface {
            var app: PhoneApp
            var interface: Interface

            @discardableResult func thenLaunch() -> Product {
                app.launch()
                return self
            }
        }

        static func buildWithHomepageService<T: HomepageInterface>(_ service: HomepageService, interface: T) -> Product<T> {
            let stubbedRootRouter = StubRootRouter(homepageInterface: interface)
            let app = PhoneApp(rootRouter: stubbedRootRouter, homepageService: service)

            return Product(app: app, interface: interface)
        }

        static func buildWithHomepageService(_ service: HomepageService) -> Product<CapturingHomepageInterface> {
            return buildWithHomepageService(service, interface: CapturingHomepageInterface())
        }

        static func buildForSuccessfulHomepageService<T: HomepageInterface>(content: [StubHomepageItem] = [], interface: T) -> Product<T> {
            return buildWithHomepageService(SuccessfulHomepageService(content: content), interface: interface)
        }

        static func buildForSuccessfulHomepageService(content: [StubHomepageItem] = []) -> Product<CapturingHomepageInterface> {
            return buildWithHomepageService(SuccessfulHomepageService(content: content))
        }

        static func buildForFailingHomepageService() -> Product<CapturingHomepageInterface> {
            return buildWithHomepageService(FailingHomepageService())
        }

    }

    func testWhenLaunchedTheRootInterfaceIsNavigatedTo() {
        let capturingRootRouter = CapturingRootRouter()
        let app = PhoneApp(rootRouter: capturingRootRouter, homepageService: DummyHomepageService())
        app.launch()

        XCTAssertTrue(capturingRootRouter.didNavigateToHomepage)
    }

    func testWhenNavigatingToTheHomepageTheHompageServiceIsToldToLoad() {
        let capturingHomepageService = CapturingHomepageService()
        PhoneAppTestBuilder.buildWithHomepageService(capturingHomepageService).thenLaunch()

        XCTAssertTrue(capturingHomepageService.didLoad)
    }

    func testHomepageServiceFailsToLoadWithNoExistingContentShownTellsInterfaceToShowErrorPlaceholder() {
        let context = PhoneAppTestBuilder.buildForFailingHomepageService().thenLaunch()
        XCTAssertTrue(context.interface.didShowLoadingErrorPlaceholder)
    }

    func testInvokingRefreshFromInterfaceTellsHomepageServiceToLoad() {
        let journallingHomepageService = JournallingHomepageService()
        let context = PhoneAppTestBuilder.buildWithHomepageService(journallingHomepageService).thenLaunch()
        context.interface.invokePullToRefresh()

        XCTAssertEqual(2, journallingHomepageService.numberOfLoads)
    }

    func testHomepageServiceCompletesLoadWithNoContentTellsInterfaceToShowNoContentPlaceholder() {
        let context = PhoneAppTestBuilder.buildForSuccessfulHomepageService().thenLaunch()
        XCTAssertTrue(context.interface.didShowNoContentPlaceholder)
    }

    func testHomepageServiceCompletesLoadWithSingleItemTellsInterfaceToHideNoContentPlaceholder() {
        let content = [StubHomepageItem()]
        let context = PhoneAppTestBuilder.buildForSuccessfulHomepageService(content: content).thenLaunch()
        XCTAssertTrue(context.interface.didHideNoContentPlaceholder)
    }

    func testHomepageServiceCompletesLoadWithNoContentDoesNotTellInterfaceToHideNoContentPlaceholder() {
        let context = PhoneAppTestBuilder.buildForSuccessfulHomepageService().thenLaunch()
        XCTAssertFalse(context.interface.didHideNoContentPlaceholder)
    }

    func testHomepageServiceCompletesLoadWithSingleItemDoesNotTellInterfaceToShowNoContentPlaceholder() {
        let content = [StubHomepageItem()]
        let context = PhoneAppTestBuilder.buildForSuccessfulHomepageService(content: content).thenLaunch()

        XCTAssertFalse(context.interface.didShowNoContentPlaceholder)
    }

    func testHomepageServiceCompletesLoadTellsInterfaceToHideErrorPlaceholder() {
        let context = PhoneAppTestBuilder.buildForSuccessfulHomepageService().thenLaunch()
        XCTAssertTrue(context.interface.didHideLoadingErrorPlaceholder)
    }

    func testHomepageServiceFailsToLoadHidesNoContentPlaceholder() {
        let context = PhoneAppTestBuilder.buildForFailingHomepageService().thenLaunch()
        XCTAssertTrue(context.interface.didHideNoContentPlaceholder)
    }

    func testHomepageServicesLoadsWithContentThenFailsToLoadOnRefreshTheErrorPlaceholderIsNotShown() {
        let capturingHomepageService = CapturingHomepageService()
        let context = PhoneAppTestBuilder.buildWithHomepageService(capturingHomepageService).thenLaunch()
        let content = [StubHomepageItem()]
        capturingHomepageService.simulateSuccessfulLoad(content: content)
        context.interface.invokePullToRefresh()
        capturingHomepageService.simulateFailedLoad()

        XCTAssertFalse(context.interface.didShowLoadingErrorPlaceholder)
    }

    func testHomepageServicesCompletesLoadWithSingleItemTellsInterfaceToInsertEntryAtFirstIndex() {
        let content = [StubHomepageItem()]
        let context = PhoneAppTestBuilder.buildForSuccessfulHomepageService(content: content).thenLaunch()

        XCTAssertEqual(0, context.interface.insertedItemIndex)
    }

    func testHomepageServicesCompletesLoadWithSeveralItemsTellsInterfaceToInsertEntriesWithinExpectedRange() {
        let count = Int.random(upperLimit: 100)
        let expected = 0..<count
        let content = Array(repeating: StubHomepageItem(), count: count)
        let journallingIndiciesInterface = JournallingIndexHomepageInterface()
        let context = PhoneAppTestBuilder.buildForSuccessfulHomepageService(content: content, interface: journallingIndiciesInterface).thenLaunch()

        XCTAssertTrue(expected.elementsEqual(context.interface.indicies))
    }

    func testLoadingSuccessfullyWithoutContentThenFailingToLoadOnRefreshShowsTheErrorPlaceholder() {
        let capturingHomepageService = CapturingHomepageService()
        let context = PhoneAppTestBuilder.buildWithHomepageService(capturingHomepageService).thenLaunch()
        capturingHomepageService.simulateSuccessfulLoad(content: [])
        context.interface.invokePullToRefresh()
        capturingHomepageService.simulateFailedLoad()

        XCTAssertTrue(context.interface.didShowLoadingErrorPlaceholder)
    }

    func testTheHomepageInterfaceIsToldToCommitUpdatesUsingViewModelWithSameCountOfItemsReturnByService() {
        let count = Int.random(upperLimit: 100)
        let content = Array(repeating: StubHomepageItem(), count: count)
        let context = PhoneAppTestBuilder.buildForSuccessfulHomepageService(content: content).thenLaunch()

        XCTAssertEqual(count, context.interface.committedViewModel?.numberOfItems)
    }

    func testLoadingHomepageDataShouldApplyViewModelWithTheCorrectHomepageItem() {
        let item = StubHomepageItem(title: "Some content")
        let context = PhoneAppTestBuilder.buildForSuccessfulHomepageService(content: [item]).thenLaunch()

        XCTAssertEqual(item.title, context.interface.committedViewModel?.item(at: 0).title)
    }

    func testLoadingDataThenSuccessfullyRefreshingNewContentShouldOldItemsToTheBottom() {
        let capturingHomepageService = CapturingHomepageService()
        let context = PhoneAppTestBuilder.buildWithHomepageService(capturingHomepageService).thenLaunch()
        let firstItem = StubHomepageItem(title: "Some content")
        let secondItem = StubHomepageItem(title: "New content")
        capturingHomepageService.simulateSuccessfulLoad(content: [firstItem])
        context.interface.invokePullToRefresh()
        capturingHomepageService.simulateSuccessfulLoad(content: [secondItem])

        XCTAssertEqual(firstItem.title, context.interface.committedViewModel?.item(at: 1).title)
    }

    func testLoadingDataMultipleTimesProducingTheSameItemShouldNotReplicateIt() {
        let capturingHomepageService = CapturingHomepageService()
        let context = PhoneAppTestBuilder.buildWithHomepageService(capturingHomepageService).thenLaunch()
        let item = StubHomepageItem(title: "Some content", contentIdentifier: "Unique ID")
        capturingHomepageService.simulateSuccessfulLoad(content: [item])
        context.interface.invokePullToRefresh()
        capturingHomepageService.simulateSuccessfulLoad(content: [item])

        XCTAssertEqual(1, context.interface.committedViewModel?.numberOfItems)
    }

}
