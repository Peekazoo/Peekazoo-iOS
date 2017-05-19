//
//  PeekazooHomepageAdapterTests.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 19/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo
import XCTest

protocol PeekazooServiceProtocol {

    func loadHomepage(delegate: HomepageLoadingDelegate)

}

protocol HomepageLoadingDelegate {

    func finishedLoadingHomepage()
    func failedToLoadHomepage()

}

class CapturingPeekazooService: PeekazooServiceProtocol {

    private(set) var didRequestLoadHomepage = false
    func loadHomepage(delegate: HomepageLoadingDelegate) {
        didRequestLoadHomepage = true
    }

}

struct FailingPeekazooService: PeekazooServiceProtocol {

    func loadHomepage(delegate: HomepageLoadingDelegate) {
        delegate.failedToLoadHomepage()
    }

}

struct SucceedingPeekazooService: PeekazooServiceProtocol {

    func loadHomepage(delegate: HomepageLoadingDelegate) {
        delegate.finishedLoadingHomepage()
    }

}

class PeekazooHomepageAdapter: HomepageService, HomepageLoadingDelegate {

    var service: PeekazooServiceProtocol
    var delegate: HomepageServiceLoadingDelegate?

    init(service: PeekazooServiceProtocol) {
        self.service = service
    }

    func loadHomepage(delegate: HomepageServiceLoadingDelegate) {
        self.delegate = delegate
        service.loadHomepage(delegate: self)
        delegate.homepageServiceDidFailToLoad()
        delegate.homepageServiceDidLoadSuccessfully(content: [])
    }

    func finishedLoadingHomepage() {

    }

    func failedToLoadHomepage() {

    }

}

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

}
