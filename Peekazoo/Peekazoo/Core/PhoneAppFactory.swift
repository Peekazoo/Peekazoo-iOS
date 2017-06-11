//
//  PhoneAppFactory.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 14/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import UIKit

public struct PhoneAppFactory: AppFactory {

    public func makeApplication(window: UIWindow) -> App {
        let networkAdapter = URLSessionNetworkAdapter()
        let weasylAPI = WeasylAPI(networkAdapter: networkAdapter)
        let weasylAdapter = WeasylHomepageAdapter(api: weasylAPI)
        let inkbunnyAPI = JSONInkbunnyAPI(networkAdapter: networkAdapter)
        let inkbunnyAdapter = InkbunnyHomepageAdapter(api: inkbunnyAPI)
        let service = PeekazooClient(feeds: [weasylAdapter, inkbunnyAdapter], delegateWorker: MainThreadWorker())
        let serviceAdapter = PeekazooHomepageAdapter(service: service)

        return PhoneApp(rootRouter: WindowRootRouter(window: window),
                        homepageService: serviceAdapter,
                        timeFormatter: RelativeTimeFormatter())
    }

}
