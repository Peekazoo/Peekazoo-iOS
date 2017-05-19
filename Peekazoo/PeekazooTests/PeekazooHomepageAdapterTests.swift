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

    func loadHomepage()

}

class CapturingPeekazooService: PeekazooServiceProtocol {

    private(set) var didRequestLoadHomepage = false
    func loadHomepage() {
        didRequestLoadHomepage = true
    }

}

struct PeekazooHomepageAdapter: HomepageService {

    var service: PeekazooServiceProtocol

    init(service: PeekazooServiceProtocol) {
        self.service = service
    }

    func loadHomepage(delegate: HomepageServiceLoadingDelegate) {
        service.loadHomepage()
    }

}

class PeekazooHomepageAdapterTests: XCTestCase {

    func testLoadingHomepageRequestsPeekazooServiceToLoad() {
        let capturingPeekazooService = CapturingPeekazooService()
        let adapter = PeekazooHomepageAdapter(service: capturingPeekazooService)
        adapter.loadHomepage(delegate: CapturingHomepageServiceLoadingDelegate())

        XCTAssertTrue(capturingPeekazooService.didRequestLoadHomepage)
    }

}
