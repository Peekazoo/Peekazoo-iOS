//
//  PeekazooHomepageAdapterTests.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 19/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo
import XCTest

class PeekazooHomepageAdapterTests: XCTestCase {

    func testLoadingHomepageRequestsPeekazooServiceToLoad() {
        let capturingPeekazooService = CapturingPeekazooService()
        let adapter = PeekazooHomepageAdapter(service: capturingPeekazooService)
        adapter.loadHomepage(delegate: CapturingHomepageServiceLoadingDelegate())

        XCTAssertTrue(capturingPeekazooService.didRequestLoadHomepage)
    }

    func testFailingToLoadHomepageTellsDelegateAboutFailure() {
        let failingPeekazooService = FailingPeekazooService()
        let adapter = PeekazooHomepageAdapter(service: failingPeekazooService)
        let delegate = CapturingHomepageServiceLoadingDelegate()
        adapter.loadHomepage(delegate: delegate)

        XCTAssertTrue(delegate.didFailToLoadInvoked)
    }

    func testSucceedingInLoadingHomepageTellsDelegateAboutSuccess() {
        let successfulHomepageService = SucceedingPeekazooService()
        let adapter = PeekazooHomepageAdapter(service: successfulHomepageService)
        let delegate = CapturingHomepageServiceLoadingDelegate()
        adapter.loadHomepage(delegate: delegate)

        XCTAssertTrue(delegate.didFinishLoadingInvoked)
    }

    func testSucceedingInLoadingHomepageProvidesItemsToDelegate() {
        let items = [StubHomepageItem(), StubHomepageItem(), StubHomepageItem()]
        let successfulHomepageService = SucceedingPeekazooService(items: items)
        let adapter = PeekazooHomepageAdapter(service: successfulHomepageService)
        let delegate = CapturingHomepageServiceLoadingDelegate()
        adapter.loadHomepage(delegate: delegate)

        XCTAssertEqual(true, (delegate.capturedHomepageItems as? [StubHomepageItem])?.elementsEqual(items))
    }

    func testFailingToLoadHomepageShouldNotTellDelegateAboutSuccess() {
        let failingPeekazooService = FailingPeekazooService()
        let adapter = PeekazooHomepageAdapter(service: failingPeekazooService)
        let delegate = CapturingHomepageServiceLoadingDelegate()
        adapter.loadHomepage(delegate: delegate)

        XCTAssertFalse(delegate.didFinishLoadingInvoked)
    }

    func testSucceedingInLoadingHomepageShouldNotNotifyDelegateAboutFailure() {
        let successfulHomepageService = SucceedingPeekazooService()
        let adapter = PeekazooHomepageAdapter(service: successfulHomepageService)
        let delegate = CapturingHomepageServiceLoadingDelegate()
        adapter.loadHomepage(delegate: delegate)

        XCTAssertFalse(delegate.didFailToLoadInvoked)
    }

}
