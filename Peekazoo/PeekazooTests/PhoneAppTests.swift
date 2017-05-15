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

        struct Product {
            var app: PhoneApp
            var interface: CapturingHomepageInterface
        }

        static func buildWithHomepageService(_ service: HomepageService) -> Product {
            let capturingHomepageInterface = CapturingHomepageInterface()
            let stubbedRootRouter = StubRootRouter(homepageInterface: capturingHomepageInterface)
            let app = PhoneApp(rootRouter: stubbedRootRouter, homepageService: service)

            return Product(app: app, interface: capturingHomepageInterface)
        }

        static func buildForSuccessfulHomepageService(content: [StubHomepageItem] = []) -> Product {
            return buildWithHomepageService(SuccessfulHomepageService(content: content))
        }

        static func buildForFailingHomepageService() -> Product {
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
        let context = PhoneAppTestBuilder.buildWithHomepageService(capturingHomepageService)
        context.app.launch()

        XCTAssertTrue(capturingHomepageService.didLoad)
    }

    func testWhenHomepageLoadedSuccessfullyTheHomepageInterfaceIsToldToPrepareForUpdates() {
        let context = PhoneAppTestBuilder.buildForSuccessfulHomepageService()
        context.app.launch()

        XCTAssertTrue(context.interface.didPrepareForUpdates)
    }

    func testTheHomepageInterfaceIsNotToldToPrepareForUpdatesUntilServiceLoadCompletes() {
        let capturingHomepageService = CapturingHomepageService()
        let context = PhoneAppTestBuilder.buildWithHomepageService(capturingHomepageService)
        context.app.launch()

        XCTAssertFalse(context.interface.didPrepareForUpdates)
    }

    func testTheHomepageInterfaceIsNotToldToPrepareForUpdatesWhenServiceLoadFails() {
        let context = PhoneAppTestBuilder.buildForFailingHomepageService()
        context.app.launch()

        XCTAssertFalse(context.interface.didPrepareForUpdates)
    }

    func testHomepageServiceFailsToLoadWithNoExistingContentShownTellsInterfaceToShowErrorPlaceholder() {
        let context = PhoneAppTestBuilder.buildForFailingHomepageService()
        context.app.launch()

        XCTAssertTrue(context.interface.didShowLoadingErrorPlaceholder)
    }

    func testInvokingRefreshFromInterfaceTellsHomepageServiceToLoad() {
        let journallingHomepageService = JournallingHomepageService()
        let context = PhoneAppTestBuilder.buildWithHomepageService(journallingHomepageService)
        context.app.launch()
        context.interface.invokePullToRefresh()

        XCTAssertEqual(2, journallingHomepageService.numberOfLoads)
    }

    func testHomepageServiceCompletesLoadWithNoContentTellsInterfaceToShowNoContentPlaceholder() {
        let context = PhoneAppTestBuilder.buildForSuccessfulHomepageService()
        context.app.launch()

        XCTAssertTrue(context.interface.didShowNoContentPlaceholder)
    }

    func testHomepageServiceCompletesLoadWithSingleItemTellsInterfaceToHideNoContentPlaceholder() {
        let context = PhoneAppTestBuilder.buildForSuccessfulHomepageService(content: [StubHomepageItem()])
        context.app.launch()

        XCTAssertTrue(context.interface.didHideNoContentPlaceholder)
    }

    func testHomepageServiceCompletesLoadWithNoContentDoesNotTellInterfaceToHideNoContentPlaceholder() {
        let context = PhoneAppTestBuilder.buildForSuccessfulHomepageService()
        context.app.launch()

        XCTAssertFalse(context.interface.didHideNoContentPlaceholder)
    }

    func testHomepageServiceCompletesLoadWithSingleItemDoesNotTellInterfaceToShowNoContentPlaceholder() {
        let context = PhoneAppTestBuilder.buildForSuccessfulHomepageService(content: [StubHomepageItem()])
        context.app.launch()

        XCTAssertFalse(context.interface.didShowNoContentPlaceholder)
    }

    func testHomepageServiceCompletesLoadTellsInterfaceToHideErrorPlaceholder() {
        let context = PhoneAppTestBuilder.buildForSuccessfulHomepageService()
        context.app.launch()

        XCTAssertTrue(context.interface.didHideLoadingErrorPlaceholder)
    }

    func testHomepageServiceFailsToLoadHidesNoContentPlaceholder() {
        let context = PhoneAppTestBuilder.buildForFailingHomepageService()
        context.app.launch()

        XCTAssertTrue(context.interface.didHideNoContentPlaceholder)
    }

}
