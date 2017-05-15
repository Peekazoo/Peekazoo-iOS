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

    func testWhenLaunchedTheRootInterfaceIsNavigatedTo() {
        let capturingRootRouter = CapturingRootRouter()
        let app = PhoneApp(rootRouter: capturingRootRouter, homepageService: DummyHomepageService())
        app.launch()

        XCTAssertTrue(capturingRootRouter.didNavigateToHomepage)
    }

    func testWhenNavigatingToTheHomepageTheHompageServiceIsToldToLoad() {
        let stubbedRootRouter = StubRootRouter()
        let capturingHomepageService = CapturingHomepageService()
        let app = PhoneApp(rootRouter: stubbedRootRouter, homepageService: capturingHomepageService)
        app.launch()

        XCTAssertTrue(capturingHomepageService.didLoad)
    }

    func testWhenHomepageLoadedSuccessfullyTheHomepageInterfaceIsToldToPrepareForUpdates() {
        let capturingHomepageInterface = CapturingHomepageInterface()
        let stubbedRootRouter = StubRootRouter(homepageInterface: capturingHomepageInterface)
        let successfulHomepageService = SuccessfulHomepageService()
        let app = PhoneApp(rootRouter: stubbedRootRouter, homepageService: successfulHomepageService)
        app.launch()

        XCTAssertTrue(capturingHomepageInterface.didPrepareForUpdates)
    }

    func testTheHomepageInterfaceIsNotToldToPrepareForUpdatesUntilServiceLoadCompletes() {
        let capturingHomepageInterface = CapturingHomepageInterface()
        let stubbedRootRouter = StubRootRouter(homepageInterface: capturingHomepageInterface)
        let capturingHomepageService = CapturingHomepageService()
        let app = PhoneApp(rootRouter: stubbedRootRouter, homepageService: capturingHomepageService)
        app.launch()

        XCTAssertFalse(capturingHomepageInterface.didPrepareForUpdates)
    }

    func testTheHomepageInterfaceIsNotToldToPrepareForUpdatesWhenServiceLoadFails() {
        let capturingHomepageInterface = CapturingHomepageInterface()
        let stubbedRootRouter = StubRootRouter(homepageInterface: capturingHomepageInterface)
        let failingHomepageService = FailingHomepageService()
        let app = PhoneApp(rootRouter: stubbedRootRouter, homepageService: failingHomepageService)
        app.launch()

        XCTAssertFalse(capturingHomepageInterface.didPrepareForUpdates)
    }

    func testHomepageServiceFailsToLoadWithNoExistingContentShownTellsInterfaceToShowErrorPlaceholder() {
        let capturingHomepageInterface = CapturingHomepageInterface()
        let stubbedRootRouter = StubRootRouter(homepageInterface: capturingHomepageInterface)
        let failingHomepageService = FailingHomepageService()
        let app = PhoneApp(rootRouter: stubbedRootRouter, homepageService: failingHomepageService)
        app.launch()

        XCTAssertTrue(capturingHomepageInterface.didShowLoadingErrorPlaceholder)
    }

    func testInvokingRefreshFromInterfaceTellsHomepageServiceToLoad() {
        let capturingHomepageInterface = CapturingHomepageInterface()
        let stubbedRootRouter = StubRootRouter(homepageInterface: capturingHomepageInterface)
        let journallingHomepageService = JournallingHomepageService()
        let app = PhoneApp(rootRouter: stubbedRootRouter, homepageService: journallingHomepageService)
        app.launch()
        capturingHomepageInterface.invokePullToRefresh()

        XCTAssertEqual(2, journallingHomepageService.numberOfLoads)
    }

    func testHomepageServiceCompletesLoadWithNoContentTellsInterfaceToShowNoContentPlaceholder() {
        let capturingHomepageInterface = CapturingHomepageInterface()
        let stubbedRootRouter = StubRootRouter(homepageInterface: capturingHomepageInterface)
        let successfulHomepageService = SuccessfulHomepageService()
        let app = PhoneApp(rootRouter: stubbedRootRouter, homepageService: successfulHomepageService)
        app.launch()

        XCTAssertTrue(capturingHomepageInterface.didShowNoContentPlaceholder)
    }

}
