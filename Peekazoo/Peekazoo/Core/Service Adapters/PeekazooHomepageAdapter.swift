//
//  PeekazooHomepageAdapter.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 19/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

public struct PeekazooHomepageAdapter: HomepageService {

    private var service: PeekazooServiceProtocol

    public init(service: PeekazooServiceProtocol) {
        self.service = service
    }

    public func loadHomepage(delegate: HomepageServiceLoadingDelegate) {
        service.loadHomepage(delegate: HomepageLoadingDelegateAdapter(delegate: delegate))
    }

    private struct HomepageLoadingDelegateAdapter: HomepageLoadingDelegate {

        var delegate: HomepageServiceLoadingDelegate

        func finishedLoadingHomepage(items: [HomepageItem]) {
            delegate.homepageServiceDidLoadSuccessfully(content: items)
        }

        func failedToLoadHomepage() {
            delegate.homepageServiceDidFailToLoad()
        }

    }

}
