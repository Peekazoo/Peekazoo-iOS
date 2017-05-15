//
//  PhoneAppTests.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 14/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo
import XCTest

class SuccessfulHomepageService: HomepageService {

    func loadHomepage() {

    }

}

class CapturingHomepageInterface: HomepageInterface {

    private(set) var didPrepareForUpdates = false
    func prepareForUpdates() {
        didPrepareForUpdates = true
    }

}

class PhoneAppTests: XCTestCase {

    func testWhenLaunchedTheRootInterfaceIsNavigatedTo() {
        let capturingRootRouter = CapturingRootRouter()
        let app = PhoneApp(rootRouter: capturingRootRouter, homepageService: DummyHomepageService())
        app.launch()

        XCTAssertTrue(capturingRootRouter.didNavigateToHomepage)
    }

    func testWhenNavigatingToTheHomepageTheHompageServiceIsToldToLoad() {
        let capturingRootRouter = CapturingRootRouter()
        let capturingHomepageService = CapturingHomepageService()
        let app = PhoneApp(rootRouter: capturingRootRouter, homepageService: capturingHomepageService)
        app.launch()

        XCTAssertTrue(capturingHomepageService.didLoad)
    }

    func testWhenHomepageLoadedSuccessfullyTheHomepageInterfaceIsToldToPrepareForUpdates() {
        let capturingRootRouter = CapturingRootRouter()
        let capturingHomepageInterface = CapturingHomepageInterface()
        capturingRootRouter.stubHomepageInterface = capturingHomepageInterface
        let successfulHomepageService = SuccessfulHomepageService()
        let app = PhoneApp(rootRouter: capturingRootRouter, homepageService: successfulHomepageService)
        app.launch()

        XCTAssertTrue(capturingHomepageInterface.didPrepareForUpdates)
    }

}
